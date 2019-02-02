(abaK is still in alpha stage. Its API can change. Please don't use it for production objects just yet. Wait for a release.)

# abaK

A powerful yet simple ABAP library to manage constants.

## Why
Nowadays, whenever a constant is needed in a program, it has to be hard coded, stored in a dedicated custom ZTABLE or, even worse, stored in the standard table TVARVC (or similar).

## What
`abaK` aims to become the standard constants library that `ABAP` so desperately needs.

It's single design goal is to **address most common needs** while still being **extremely easy to use**, by both developers and functional people alike. And if its standard functionality doesn't cover your particular needs, you can easily extend it.

With `abaK` you can finally stop developing a new `ZCONSTANTS` table every time you need one. Or, even worse, stop storing your constants in obscure standard tables like `TVARVC`.

## How
abaK offers a simple yet powerful and flexible way for any program to manage its constants. Advantages of using abaK:
- decentralized: there is no monolithic table holding all the constants. One program can decide to have its own constants source.
- easily customized: a project can decide to have its constants maintainable directly in PRD while another may required them to be maintained in DEV and then transported;
- multiple scopes: some constants can be used system-wide while others can belong to a single program and no one else will mess with them;
- system-wide management: constant sources are registered in a central table so that it is easy to keep track of the existing data sources; 
- different formats: besides a database table it accepts `CSV`, `XML` and `JSON`;
- different content locations: besides providing it inline, content can be fetched from an `URL`, a server file or even another system; 
- extensible: if needed, new format/content readers can be created (ex.: to read legacy data in a specific data format).  

Providing a well-defined API, abaK clearly separates the way it is used from the way the constants are stored.

Documentation in the [wiki](https://github.com/abapinho/abak/wiki).

## Requirements
* ABAP Version: 702 or higher.
* [abapGit](https://abapgit.org)

## FAQ
For questions/comments/bugs/feature requests/wishes please create an [issue](https://github.com/abapinho/abak/issues).
CSV
