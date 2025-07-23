const express = require('express');
const axios = require('axios');
const unzipper = require('unzipper');
const archiver = require('archiver');
const path = require('path');
const fs = require('fs');
const fsp = require('fs').promises;
const { exec } = require('child_process');
const app = express ();
app.use(express.json());

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log("Server Listening on PORT:", PORT);
});

app.get("/status", (request, response) => {
    const status = {
        "Status": "Running"
    };
    response.send(status);
});

const dynamic_folder = path.join(__dirname, 'placeholder');

app.use('/app/data', express.static('fabric-ca-client'));

app.get('/mkdir/:name', (request, response) => {
    const newFolder = path.join(dynamic_folder, request.params.name);
    
    if (!fs.existsSync(newFolder)) {
        fs.mkdirSync(newFolder, { recursive: true });
    }

    response.send('Folder created and exposed');
});

app.post('/zip-folder', async (req, res) => {
    const { sourceFolder, zipPath } = req.body;

    if (!sourceFolder || !zipPath) {
        return res.status(400).json({ error: 'Source folder and zip path are required.' });
    }

    try {
        // Ensure source folder exists
        if (!fs.existsSync(sourceFolder)) {
            return res.status(404).json({ error: 'Source folder not found.' });
        }

        // Create write stream for zip file
        const output = fs.createWriteStream(zipPath);
        const archive = archiver('zip', { zlib: { level: 9 } });

        output.on('close', () => {
            console.log(`Created zip: ${zipPath} (${archive.pointer()} bytes)`);
            res.status(200).json({ message: 'Folder zipped successfully.', size: archive.pointer() });
        });

        output.on('error', (err) => {
            console.error('Write stream error:', err);
            res.status(500).json({ error: 'Failed to create zip file.' });
        });

        archive.pipe(output);
        archive.directory(sourceFolder, false); // 'false' means no parent folder in the zip
        await archive.finalize();

    } catch (error) {
        console.error('Zipping error:', error);
        res.status(500).json({ error: 'Failed to zip folder.' });
    }
});

app.post('/copy-msp', async (req, res) => {
    const { sourcePath, destinationPath } = req.body;

    if (!sourcePath || !destinationPath) {
        return res.status(400).json({ error: 'Source and destination paths are required.' });
    }

    try {
        // Ensure the destination directory exists
        if (!fssync.existsSync(destinationPath)) {
            await fsp.mkdir(destinationPath, { recursive: true });
        }

        // Download the ZIP file from the URL and extract it directly to the destination
        const response = await axios({
            method: 'get',
            url: sourcePath,
            responseType: 'stream'
        });

        // Pipe the ZIP stream to unzipper
        await new Promise((resolve, reject) => {
            response.data
                .pipe(unzipper.Extract({ path: destinationPath }))
                .on('close', resolve)
                .on('error', reject);
        });

        res.status(200).json({ message: 'Folder downloaded and extracted successfully.' });
    } catch (error) {
        console.error('Error copying folder from URL:', error);
        res.status(500).json({ error: 'Failed to copy folder from URL.' });
    }
});

const allowedCommands = new Set([
    'fabric-ca-client'
]);

app.post('/enroll', (request, response) => {
    const {command} = request.body;
    if (!command) {
        return response.status(400).json({ error: 'No command provided' });
    }

    // Extract base command (first word)
    const baseCommand = command.trim().split(/\s+/)[0];

    if (!allowedCommands.has(baseCommand)) {
        return response.status(403).json({ error: `Command "${commandName}" is not allowed` });
    }

    exec(command, (error, stdout, stderr) => {
        if (error) {
            return response.status(500).json({
                error: error.message,
                stderr,
                stdout
            });
        }

        response.json({ stdout, stderr });
    });
});