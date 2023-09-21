/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { should, expect } from 'chai';
import { getNullChannel } from '../../../test/unitTests/fakes';
import { CsharpChannelObserver } from '../../../src/shared/observers/csharpChannelObserver';
import {
    InstallationFailure,
    DebuggerNotInstalledFailure,
    DebuggerPrerequisiteFailure,
    ProjectJsonDeprecatedWarning,
    BaseEvent,
    PackageInstallStart,
    IntegrityCheckFailure,
} from '../../../src/omnisharp/loggingEvents';

suite('CsharpChannelObserver', () => {
    suiteSetup(() => should());
    [
        new InstallationFailure('someStage', 'someError'),
        new DebuggerNotInstalledFailure(),
        new DebuggerPrerequisiteFailure('some failure'),
        new ProjectJsonDeprecatedWarning(),
        new IntegrityCheckFailure('', '', true),
        new PackageInstallStart(),
    ].forEach((event: BaseEvent) => {
        test(`${event.constructor.name}: Channel is shown and preserve focus is set to true`, () => {
            let hasShown = false;
            let preserveFocus = false;
            const observer = new CsharpChannelObserver({
                ...getNullChannel(),
                show: (preserve) => {
                    hasShown = true;
                    preserveFocus = preserve ?? false;
                },
            });

            observer.post(event);
            expect(hasShown).to.be.true;
            expect(preserveFocus).to.be.true;
        });
    });
});
