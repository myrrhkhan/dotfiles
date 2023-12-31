# Syntax highlighting guide

## Info on TextMate

VS Code's syntax highlighting is written with the TextMate grammar. It's a grammar that makes heavy use of regular expressions. So make sure you brush up your skill on backward/forward references and lookarounds, because all these can be used. TextMate is a greedy grammar, which means that unlike normal regular expressions it will not backtrack. Once a match is found, that will be used. The other important thing is that the grammar can be nested, but children of a match can exceed the parent match and therefore push the boundaries of the parent match.

A good document to read in more detail about TextMate: https://www.apeth.com/nonblog/stories/textmatebundle.html

## Developing the grammar

The grammar for pug and markdown is written in JSON. You can edit that directly. The main grammar is written in `yaml` because that's easier to structure than JSON. However, VS Code expects a JSON format. Therefore you need to run the `build:`grammar` script afterward. This will produce a JSON version of the file. Afterward, you need to restart your extension window for the changes to take effect.

### Snapshot test for the grammar

The snapshot test is run by [vscode-textmate-test](https://github.com/PanAeon/vscode-tmgrammar-test). The `test` command calls a node script to build the argument and execute the `vscode-textmate-test` command. If you updated the svelte grammar file, Be sure to add the test cases to the `test/sample` directory.

Then run the test to check if the update affects existing cases

```bash
pnpm run test
```

Update existing snapshots to match the changes

```bash
pnpm run test -- --updateSnapshot
```
