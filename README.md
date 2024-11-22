# About Ordnung

Keep all you files organized.

Ordnung gives you an overview of all your files stored somewhere and can

* find duplicates
* assign tags

## Ordnung Library

This is the backend component, shared with ordnung-client and
ordnung-server to

* encapsulate the data store
* provide abstractions for Documents, Tags, etc.

## Installation

gem build

## Internals

### Toplevel

It is assumed that one wants to index files, many files, organized in
directories or archives (tarball, zip, iso, disk image, ...)

Each of these file is *uniquely* identified by
- its name, date, type, size and sha256sum
 - the type is derived from the file name extension
   or by running the `file` command

- additionally a file has a parent, usually the directory where the
  file resides on disk. But could also be an archive, iso, disk image,
  etc.

- directories also have parents, thus building the complete file
  system hierachy

- depending on file type, a file will get additional properties
  (a picture has a resolution, etc.)

- on top of that are tags. Tags are also hierachical, so they
  have a name and a parent.
  Think of `family:uncle:bob` as such a hierachical tag.

- files can get any number of tags


- the (abstract) file representation is the `Gizmo`
  Gizmo represents a file, resp. specific file types with specific
  properties

- the toplevel API is provided by Ordnung::Ordnung
  An Ordnung instance can
  - import a file
    - split it into its file path components, determine its type, and,
      based on the type, call the actual importer which knows the
      additional properties and how to extract them.
    - collect properties and store them
    - retrieve a set of properties from the database and construct the
      corresponding in-memory instance
  - add and remove tags
  - filter by tags

### Implementation details

`Name` is the most basic class, storing an arbitrary string in the
database and thus giving it and id for easy access and comparison.
It esp. ensures uniqueness of strings within the system. Each string
is stored once and referenced by its (database) id.

Files and directories have names (the filename), as do Tags.

`Tag` is a combination of a Name and a parent tag - building a tag
hierachy.

`Tagging` links a `Tag` with a `Gizmo` - effectively implementing the
actual tagging.


## Database considerations

Everything is stored in a single database (that is only the file
metadata, like name, path, date, checksum, tags, etc. - not the actual
file content)

Split into the following tables

- `ordnung-gizmos`
  all gizmos (name with a parent and any number of additional
  properties. esp. a type property determining the actual Gizmo
  implementation)

- `ordnung-names`
  string storage. Every record is a single string, identified by its
  database id

- `ordnung-tags`
  tag storage. Every record is the combination of a Name id (string
  value of the tag element) and a parent id (pointing to the parent tag)

- `ordnung-taggings`
  pairs of (tag, gizmo) ids, linking tags to gizmos (well, files
  actually)
