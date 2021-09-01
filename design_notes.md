# Design Notes for sql2puml

# ADR
## ADR-1 Language
Written in **awk** as originally conceived of project processing one line at a time with use of pattern matching

## ADR-2 Output Format
Initial format will be plantUML (puml) as easy to cehck output syntax using an IDE plugin

# Future Ideas
1. convert to python
2. options for various output formats (puml, mermaid, markdown table)
3. testing with more versions of SQL (as dumped from databases to get the schema)
