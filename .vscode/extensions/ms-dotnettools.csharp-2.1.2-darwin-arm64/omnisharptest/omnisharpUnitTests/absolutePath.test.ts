/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { expect } from 'chai';
import { AbsolutePath } from '../../src/packageManager/absolutePath';
import { TmpAsset, CreateTmpFile } from '../../src/createTmpAsset';
import { join } from 'path';

suite(AbsolutePath.name, () => {
    let tmpPath: TmpAsset;

    setup(async () => {
        tmpPath = await CreateTmpFile();
    });

    teardown(() => {
        tmpPath.dispose();
    });

    test('Throws error when the passed value is not an absolute path', () => {
        expect(() => new AbsolutePath('somePath')).to.throw(Error);
    });

    test(`${AbsolutePath.getAbsolutePath.name}: Returns an absolute path based by resolving the path with the value to prepend`, () => {
        const absolutePath = AbsolutePath.getAbsolutePath(tmpPath.name, 'somePath');
        expect(absolutePath.value).to.be.equal(join(tmpPath.name, 'somePath'));
    });
});
