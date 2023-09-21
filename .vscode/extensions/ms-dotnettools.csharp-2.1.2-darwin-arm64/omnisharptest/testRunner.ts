/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as path from 'path';
import * as Mocha from 'mocha';
import * as glob from 'glob-promise';
import * as fs from 'fs';
import * as vscode from 'vscode';
import { SubscribeToAllLoggers } from '../src/logger';
import * as tty from 'tty';

// Linux: prevent a weird NPE when mocha on Linux requires the window size from the TTY
// Since we are not running in a tty environment, we just implementt he method statically
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
tty.getWindowSize = function () {
    return [80, 75];
};

function setupLogging() {
    if (process.env.CODE_EXTENSIONS_PATH && process.env.OSVC_SUITE) {
        const logDirPath = path.join(process.env.CODE_EXTENSIONS_PATH, './.logs');

        if (!fs.existsSync(logDirPath)) {
            fs.mkdirSync(logDirPath);
        }

        const logFilePath = path.join(logDirPath, `${process.env.OSVC_SUITE}.log`);

        SubscribeToAllLoggers((message) => fs.appendFileSync(logFilePath, message));
    }
}

export async function run(testsRoot: string, options?: Mocha.MochaOptions) {
    options ??= {
        ui: 'tdd',
        useColors: true,
        retries: 2,
    };

    const configuration = vscode.workspace.getConfiguration();
    const enableLspDriver = configuration.get<boolean | undefined>('omnisharp.enableLspDriver', undefined);
    configuration.update('omnisharp.enableLspDriver', process.env.OMNISHARP_DRIVER === 'lsp' ? true : false);

    const mocha = new Mocha(options);

    setupLogging();

    // Glob test files
    const files = await glob('**/**.test.js', { cwd: testsRoot });

    // Fill into Mocha
    files.forEach((file) => mocha.addFile(path.join(testsRoot, file)));

    return new Promise<number>((resolve) => {
        mocha.run(resolve);
    }).then((failures) => {
        if (failures > 0) {
            throw new Error(`${failures} tests failed.`);
        }

        configuration.update('omnisharp.enableLspDriver', enableLspDriver);
    });
}
