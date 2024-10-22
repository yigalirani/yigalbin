#!/usr/bin/env node
const fs = require('fs').promises;
const path = require('path');
const { exec } = require('child_process');

// Promisified exec to run commands asynchronously
function execAsync(command) {
    return new Promise((resolve, reject) => {
        exec(command, (error, stdout, stderr) => {
            if (error) {
                reject(stderr || error);
            } else {
                resolve(stdout);
            }
        });
    });
}

// Recursively walk through the directory to find all .ts files, excluding node_modules and dist
async function findTsFiles(dir) {
    let results = [];
    const list = await fs.readdir(dir);

    for (const file of list) {
        const filePath = path.join(dir, file);
        const stat = await fs.stat(filePath);

        if (stat.isDirectory()) {
            if (file !== 'node_modules' && file !== 'dist') {
                const subDirFiles = await findTsFiles(filePath);  // Recurse into subdirectory
                results = results.concat(subDirFiles);
            }
        } else if (filePath.endsWith('.ts')) {
            results.push(filePath);  // Collect .ts file
        }
    }
    return results;
}

// Perform the replacement of ") {" with "){"
function replaceBrackets(input) {
  return input.replaceAll(/\r\n/g,'\n')
  .replaceAll(/( *\n *\n)+/g,'\n')
  .replaceAll(/(?<=[\]}{):=]) +(?=[=[{])/g,'')
  .replaceAll(/(?<=[:=>]) +(?=\w)/g,'')
  .replaceAll(/(?<=\w) +(?=[={])/g,'')  
  .replaceAll(/import{/g,'import {')  
  .replaceAll(/const{/g,'const {') 
  .replaceAll(/return{/g,'return {') 

//  .replaceAll(/^const\{/g,'const {') 
}

// Process a file: run tsfmt, replace ") {" with "){", and write back to the same location
async function processFile(filePath) {
    try {
        console.log(`Processing file: ${filePath}`);

        // Run tsfmt on the file asynchronously
        //await execAsync(`tsfmt --replace ${filePath}`);
        
        // Read the newly formatted file asynchronously
        let formattedCode = await fs.readFile(filePath, 'utf-8');

        // Replace ") {" with "){"
        let modifiedCode = replaceBrackets(formattedCode);

        // Write the modified code back to the file asynchronously
        await fs.writeFile(filePath, modifiedCode, 'utf-8');
        
        console.log(`Processed and modified file: ${filePath}`);
    } catch (error) {
        console.error(`Failed to process file: ${filePath}`, error);
    }
}

// Main function
async function main(startDir) {
    try {
        const tsFiles = await findTsFiles(startDir);
        const promises = tsFiles.map(processFile);  // Create a promise for each file processing
        await Promise.all(promises);  // Wait for all files to be processed
        console.log('All files processed successfully.');
    } catch (error) {
        console.error('Error during file processing:', error);
    }
}

// Main function
async function main(startDir) {
    const tsFiles = await findTsFiles(startDir);
    console.log(tsFiles)
    tsFiles.forEach(processFile);
}

// Get the starting directory from command line arguments
const startDir = process.argv[2] || '/yigal/million_try3';

// Start scanning
main(startDir);