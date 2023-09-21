/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as path from 'path';
import * as vscode from 'vscode';
import * as jsonc from 'jsonc-parser';
// import { FormattingOptions } from 'jsonc-parser';

import {
    AssetGenerator,
    ProgramLaunchType,
    replaceCommentPropertiesWithComments,
    updateJsonWithComments,
} from '../../src/shared/assets';
import { parse } from 'jsonc-parser';
import { use, should } from 'chai';
import * as chaiString from 'chai-string';
import { ProjectDebugInformation } from '../../src/shared/IWorkspaceDebugInformationProvider';
import { findNetCoreTargetFramework } from '../../src/shared/utils';
import { isNotNull } from '../testUtil';

use(chaiString);

suite('Asset generation: csproj', () => {
    suiteSetup(() => should());

    test('Create tasks.json for project opened in workspace', () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'testApp.csproj'),
            'testApp',
            'netcoreapp1.0'
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const tasksJson = generator.createTasksConfiguration();
        isNotNull(tasksJson.tasks);
        isNotNull(tasksJson.tasks[0].args);
        const buildPath = tasksJson.tasks[0].args[1];

        // ${workspaceFolder}/project.json
        const segments = buildPath.split(path.posix.sep);
        segments.should.deep.equal(['${workspaceFolder}', 'testApp.csproj']);
    });

    test("Generated 'build' and 'publish' tasks have the property GenerateFullPaths set to true ", () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'testApp.csproj'),
            'testApp',
            'netcoreapp1.0'
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const tasksJson = generator.createTasksConfiguration();
        isNotNull(tasksJson.tasks);

        // We do not check the watch task since this parameter can break hot reload scenarios.
        tasksJson.tasks
            .filter((task) => task.label !== 'watch')
            .forEach((task) => task.args!.should.contain('/property:GenerateFullPaths=true'));
    });

    test("Generated 'build' and 'publish' tasks have the consoleloggerparameters argument set to NoSummary", () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'testApp.csproj'),
            'testApp',
            'netcoreapp1.0'
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const tasksJson = generator.createTasksConfiguration();
        isNotNull(tasksJson.tasks);

        // We do not check the watch task since this parameter can break hot reload scenarios.
        tasksJson.tasks
            .filter((task) => task.label !== 'watch')
            .forEach((task) => task.args!.should.contain('/consoleloggerparameters:NoSummary'));
    });

    test("Generated 'watch' task does not have the property GenerateFullPaths set to true ", () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'testApp.csproj'),
            'testApp',
            'netcoreapp1.0'
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const tasksJson = generator.createTasksConfiguration();
        isNotNull(tasksJson.tasks);

        const watchTask = tasksJson.tasks.find((task) => task.label === 'watch');
        isNotNull(watchTask?.args);
        watchTask.args.should.not.contain('/property:GenerateFullPaths=true');
    });

    test("Generated 'watch' task does not have the consoleloggerparameters argument set to NoSummary", () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'testApp.csproj'),
            'testApp',
            'netcoreapp1.0'
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const tasksJson = generator.createTasksConfiguration();

        const watchTask = tasksJson.tasks!.find((task) => task.label === 'watch');
        isNotNull(watchTask?.args);
        watchTask.args.should.not.contain('/consoleloggerparameters:NoSummary');
    });

    test('Create tasks.json for nested project opened in workspace', () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'nested', 'testApp.csproj'),
            'testApp',
            'netcoreapp1.0'
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const tasksJson = generator.createTasksConfiguration();
        isNotNull(tasksJson.tasks);
        isNotNull(tasksJson.tasks[0].args);
        const buildPath = tasksJson.tasks[0].args[1];

        // ${workspaceFolder}/nested/project.json
        const segments = buildPath.split(path.posix.sep);
        segments.should.deep.equal(['${workspaceFolder}', 'nested', 'testApp.csproj']);
    });

    test('Create launch.json for project opened in workspace', () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'testApp.csproj'),
            'testApp',
            'netcoreapp1.0'
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const launchJson = parse(generator.createLaunchJsonConfigurations(ProgramLaunchType.Console), undefined, {
            disallowComments: true,
        });
        const programPath: string = launchJson[0].program;

        checkProgramPath(rootPath, programPath, info[0].outputPath);
    });

    [5, 6, 7, 8, 9].forEach((version) => {
        const shortName = `net${version}.0`;

        test(`Create launch.json for NET ${version} project opened in workspace with shortname '${shortName}'`, () => {
            const rootPath = path.resolve('testRoot');
            const info = createMSBuildWorkspaceInformation(
                path.join(rootPath, 'testApp.csproj'),
                'testApp',
                shortName,
                /*targetPath*/ undefined,
                /*isExe*/ true
            );
            const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
            generator.setStartupProject(0);
            const launchJson = parse(generator.createLaunchJsonConfigurations(ProgramLaunchType.Console), undefined, {
                disallowComments: true,
            });
            const programPath: string = launchJson[0].program;

            checkProgramPath(rootPath, programPath, info[0].outputPath);
        });
    });

    test('Create launch.json for nested project opened in workspace', () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'nested', 'testApp.csproj'),
            'testApp',
            'netcoreapp1.0'
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const launchJson = parse(generator.createLaunchJsonConfigurations(ProgramLaunchType.Console), undefined, {
            disallowComments: true,
        });
        const programPath: string = launchJson[0].program;

        checkProgramPath(rootPath, programPath, info[0].outputPath);
    });

    test('Create launch.json for project opened in workspace with non-relative output path', function () {
        if (process.platform !== 'win32') {
            this.skip();
        }

        const rootPath = path.resolve('testRoot');
        const differentDrive = rootPath.startsWith('C:') ? 'D:' : 'C:';
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'testApp.csproj'),
            'testApp',
            'netcoreapp1.0',
            `${differentDrive}\\output.dll`
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const launchJson = parse(generator.createLaunchJsonConfigurations(ProgramLaunchType.Console), undefined, {
            disallowComments: true,
        });
        const programPath: string = launchJson[0].program;

        checkProgramPath(rootPath, programPath, info[0].outputPath);
    });

    test('Create launch.json for Blazor web assembly standalone project opened in workspace', () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'testApp.csproj'),
            'testApp',
            'netstandard2.1',
            /*targetPath*/ undefined,
            /*isExe*/ true,
            /*isWebProject*/ true,
            /*isBlazorWebAssemblyStandalone*/ true
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const launchJson = parse(
            generator.createLaunchJsonConfigurations(ProgramLaunchType.BlazorWebAssemblyStandalone),
            undefined,
            { disallowComments: true }
        );
        const blazorLaunchConfig = launchJson[0];
        const type = blazorLaunchConfig.type;

        type.should.equal('blazorwasm');
    });

    test('Create launch.json for nested Blazor web assembly standalone project opened in workspace', () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'nested', 'testApp.csproj'),
            'testApp',
            'netstandard2.1',
            /*targetPath*/ undefined,
            /*isExe*/ true,
            /*isWebProject*/ true,
            /*isBlazorWebAssemblyStandalone*/ true
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const launchJson = parse(
            generator.createLaunchJsonConfigurations(ProgramLaunchType.BlazorWebAssemblyStandalone),
            undefined,
            { disallowComments: true }
        );
        const blazorLaunchConfig = launchJson[0];
        const cwd = blazorLaunchConfig.cwd;

        cwd.should.equal('${workspaceFolder}/nested');
    });

    test('Create launch.json for Blazor web assembly hosted project opened in workspace', () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'testApp.csproj'),
            'testApp',
            'netcoreapp3.0',
            /*targetPath*/ undefined,
            /*isExe*/ true,
            /*isWebProject*/ true,
            /*isBlazorWebAssemblyStandalone*/ false,
            /*isBlazorWebAssemblyHosted*/ true
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const launchJson = parse(
            generator.createLaunchJsonConfigurations(ProgramLaunchType.BlazorWebAssemblyHosted),
            undefined,
            { disallowComments: true }
        );
        const hostedBlazorLaunchConfig = launchJson[0];
        const programPath: string = hostedBlazorLaunchConfig.program;
        const cwd = hostedBlazorLaunchConfig.cwd;
        const hosted = hostedBlazorLaunchConfig.hosted;

        checkProgramPath(rootPath, programPath, info[0].outputPath);

        cwd.should.equal('${workspaceFolder}');
        hosted.should.equal(true);
    });

    test('Create launch.json for nested Blazor web assembly hosted project opened in workspace', () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'nested', 'testApp.csproj'),
            'testApp',
            'netcoreapp3.0',
            /*targetPath*/ undefined,
            /*isExe*/ true,
            /*isWebProject*/ true,
            /*isBlazorWebAssemblyStandalone*/ false,
            /*isBlazorWebAssemblyHosted*/ true
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const launchJson = parse(
            generator.createLaunchJsonConfigurations(ProgramLaunchType.BlazorWebAssemblyHosted),
            undefined,
            { disallowComments: true }
        );
        const hostedBlazorLaunchConfig = launchJson[0];
        const programPath: string = hostedBlazorLaunchConfig.program;
        const cwd = hostedBlazorLaunchConfig.cwd;
        const hosted = hostedBlazorLaunchConfig.hosted;

        checkProgramPath(rootPath, programPath, info[0].outputPath);

        cwd.should.equal('${workspaceFolder}/nested');
        hosted.should.equal(true);
    });

    test('Create launch.json for web project opened in workspace', () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'testApp.csproj'),
            'testApp',
            'netcoreapp1.0',
            /*targetPath*/ undefined,
            /*isExe*/ true,
            /*isWebProject*/ true
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const launchJson = parse(generator.createLaunchJsonConfigurations(ProgramLaunchType.Web), undefined, {
            disallowComments: true,
        });
        const programPath: string = launchJson[0].program;

        checkProgramPath(rootPath, programPath, info[0].outputPath);
    });

    test('Create launch.json for nested web project opened in workspace', () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'nested', 'testApp.csproj'),
            'testApp',
            'netcoreapp1.0',
            /*targetPath*/ undefined,
            /*isExe*/ true,
            /*isWebProject*/ true
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const launchJson = parse(generator.createLaunchJsonConfigurations(ProgramLaunchType.Web), undefined, {
            disallowComments: true,
        });
        const programPath: string = launchJson[0].program;

        checkProgramPath(rootPath, programPath, info[0].outputPath);
    });

    test('Add a new item to JSON', () => {
        const existingItem = { name: 'existing-item' };
        const original = {
            configurations: [existingItem],
        };

        const newItem = { name: 'new-item' };
        const updated = updateJsonWithComments(
            JSON.stringify(original),
            [newItem],
            'configurations',
            'name',
            /*formattingOptions*/ null!
        );
        const parsed = jsonc.parse(updated);
        const configurations = parsed.configurations;

        const expected = [existingItem, newItem];
        configurations.should.deep.equal(expected);
    });

    test('Update item in JSON', () => {
        const existingItem = { name: 'existing-item', command: 'cmd' };
        const original = {
            configurations: [
                // this should update to have command dotnet, because the name is the same as our updated item
                { name: 'build', command: 'old value' },
                existingItem,
            ],
        };

        const updatedItem = { name: 'build', command: 'dotnet' };

        const updated = updateJsonWithComments(
            JSON.stringify(original),
            [updatedItem],
            'configurations',
            'name',
            /*formattingOptions*/ null!
        );
        const parsed = jsonc.parse(updated);
        const configurations = parsed.configurations;

        const expected = [updatedItem, existingItem];
        configurations.should.deep.equal(expected);
    });

    test('Update JSON and preserve all comments', () => {
        const original = `
        // user comment in file
        {
            "configurations": [
                { "name": "build", "command": "old value" },
                {
                    // user comment in their configuration
                    "name": "existing-item",
                    "command": "cmd"
                }
            ]
        }`;

        const updatedItem = { name: 'build', command: 'dotnet' };

        const updated = updateJsonWithComments(
            original,
            [updatedItem],
            'configurations',
            'name',
            /*formattingOptions*/ null!
        );
        const lines = updated.trim().split('\n');

        lines[0].trim().should.equal('// user comment in file');
        lines[5].trim().should.equal('// user comment in their configuration');
    });

    test('Replace items named OS-COMMENTxxx with JSON comment syntax', () => {
        const original = `
        {
            "configurations": [
                {
                    "name": "build",
                    "OS-COMMENT": "This is a dotnet build command",
                    "OS-COMMENT2": "this is the default command.",
                    "command": "dotnet build"
                },
            ]
        }`;

        const updated = replaceCommentPropertiesWithComments(original);
        const lines = updated.trim().split('\n');

        lines[4].trim().should.equal('// This is a dotnet build command');
        lines[5].trim().should.equal('// this is the default command.');
    });

    test('createLaunchJsonConfigurationsArray removes comments', () => {
        const rootPath = path.resolve('testRoot');
        const info = createMSBuildWorkspaceInformation(
            path.join(rootPath, 'testApp.csproj'),
            'testApp',
            'netcoreapp1.0',
            /*targetPath*/ undefined,
            /*isExe*/ true,
            /*isWebProject*/ true
        );
        const generator = new AssetGenerator(info, createMockWorkspaceFolder(rootPath));
        generator.setStartupProject(0);
        const launchConfigurations: vscode.DebugConfiguration[] = generator.createLaunchJsonConfigurationsArray(
            ProgramLaunchType.Web,
            false
        );

        launchConfigurations.should.have.lengthOf(2);

        launchConfigurations[0].type.should.equal('coreclr');
        launchConfigurations[0].request.should.equal('launch');

        launchConfigurations[1].type.should.equal('coreclr');
        launchConfigurations[1].request.should.equal('attach');

        JSON.stringify(launchConfigurations).indexOf('OS-COMMENT').should.lessThan(0);
    });
});

function checkProgramPath(rootPath: string, programPath: string, targetPath: string): void {
    if (path.relative(rootPath, targetPath) !== targetPath) {
        programPath.should.startWith('${workspaceFolder}/');
        programPath.should.equal(
            targetPath.replace(rootPath, '${workspaceFolder}').replaceAll(path.win32.sep, path.posix.sep)
        );
    } else {
        programPath.should.equal(targetPath.replaceAll(path.win32.sep, path.posix.sep));
    }
}

function createMockWorkspaceFolder(rootPath: string): vscode.WorkspaceFolder {
    return {
        uri: vscode.Uri.file(rootPath),
        name: '',
        index: -1,
    };
}

function createMSBuildWorkspaceInformation(
    projectPath: string,
    assemblyName: string,
    targetFrameworkShortName: string,
    targetPath: string | undefined = undefined,
    isExe = true,
    isWebProject = false,
    isBlazorWebAssemblyStandalone = false,
    isBlazorWebAssemblyHosted = false
): ProjectDebugInformation[] {
    return [
        {
            projectPath: projectPath,
            solutionPath: null,
            targetsDotnetCore: findNetCoreTargetFramework([targetFrameworkShortName]) !== undefined,
            outputPath:
                targetPath ??
                path.join(
                    path.dirname(projectPath),
                    'bin',
                    'Debug',
                    new Date().getTime().toString(),
                    targetFrameworkShortName,
                    `${assemblyName}.dll`
                ),
            projectName: projectPath,
            isExe: isExe,
            isWebProject: isWebProject,
            isBlazorWebAssemblyHosted: isBlazorWebAssemblyHosted,
            isBlazorWebAssemblyStandalone: isBlazorWebAssemblyStandalone,
        },
    ];
}
