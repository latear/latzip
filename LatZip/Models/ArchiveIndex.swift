//
//  ArchiveIndex.swift
//  LatZip
//

import Foundation

/// Índice O(1) por carpeta para listas grandes sin recorrer el árbol cada vez.
struct ArchiveIndex: Sendable {
    private let childrenMap: [String: [ArchiveEntryRecord]]
    let sortedParentPaths: [String]
    /// Solo ficheros (no carpetas), para expansión de extracción.
    private let fileRecords: [ArchiveEntryRecord]
    /// Todas las entradas listadas (deduplicadas).
    let allRecords: [ArchiveEntryRecord]

    init(flatPaths: [(path: String, isDir: Bool, size: Int64, mtime: Date?, mode: UInt32)]) {
        var map: [String: [ArchiveEntryRecord]] = [:]
        map[""] = []
        var files: [ArchiveEntryRecord] = []
        var seenDirs: Set<String> = []
        let sortedInput = flatPaths.sorted { $0.path < $1.path }
        for item in sortedInput {
            let trimmed = item.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            guard !trimmed.isEmpty else { continue }
            let nsPath = trimmed as NSString
            let parent = nsPath.deletingLastPathComponent
            let name = nsPath.lastPathComponent
            let parentKey = parent
            let record = ArchiveEntryRecord(
                name: name,
                fullPath: trimmed,
                parentPath: parentKey,
                isFolder: item.isDir,
                byteSize: item.size,
                modified: item.mtime,
                permissionsMode: item.mode
            )
            map[parentKey, default: []].append(record)
            if item.isDir {
                seenDirs.insert(trimmed)
            } else {
                files.append(record)
            }
        }
        
        for item in sortedInput {
            let trimmed = item.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            guard !trimmed.isEmpty else { continue }
            if item.isDir {
                seenDirs.insert(trimmed)
            }
            var components = trimmed.split(separator: "/")
            while components.count > 1 {
                components.removeLast()
                let dirPath = components.joined(separator: "/")
                if !seenDirs.contains(dirPath) {
                    seenDirs.insert(dirPath)
                    let dirName = (dirPath as NSString).lastPathComponent
                    let dirParent = (dirPath as NSString).deletingLastPathComponent
                    let impliedRecord = ArchiveEntryRecord(
                        name: dirName,
                        fullPath: dirPath,
                        parentPath: dirParent,
                        isFolder: true,
                        byteSize: 0,
                        modified: nil,
                        permissionsMode: 0o755
                    )
                    map[dirParent, default: []].append(impliedRecord)
                }
            }
        }
        for k in map.keys {
            map[k]?.sort { a, b in
                if a.isFolder != b.isFolder { return a.isFolder && !b.isFolder }
                return a.name.localizedCaseInsensitiveCompare(b.name) == .orderedAscending
            }
        }
        childrenMap = map
        sortedParentPaths = map.keys.sorted()
        fileRecords = files
        var seen = Set<String>()
        var flatAll: [ArchiveEntryRecord] = []
        for arr in map.values {
            for r in arr where !seen.contains(r.fullPath) {
                seen.insert(r.fullPath)
                flatAll.append(r)
            }
        }
        flatAll.sort { $0.fullPath < $1.fullPath }
        allRecords = flatAll
    }

    func children(ofParent parentPath: String) -> [ArchiveEntryRecord] {
        childrenMap[parentPath] ?? []
    }

    func record(forFullPath path: String) -> ArchiveEntryRecord? {
        let key = (path as NSString).deletingLastPathComponent
        let target = path
        return children(ofParent: key).first { $0.fullPath == target }
    }

    /// Ficheros cuyo path (de archivo) está bajo `folderPath` (carpeta, sin barra final preferente).
    func files(underFolder folderPath: String) -> [ArchiveEntryRecord] {
        if folderPath.isEmpty {
            return fileRecords
        }
        let base = folderPath.hasSuffix("/") ? String(folderPath.dropLast()) : folderPath
        let prefix = base + "/"
        return fileRecords.filter { $0.fullPath.hasPrefix(prefix) }
    }

    var totalUncompressedBytes: Int64 {
        fileRecords.reduce(0) { $0 + max(0, $1.byteSize) }
    }

    var totalEntryCount: Int { allRecords.count }
}
