const express = require('express');
const axios = require('axios');
const unzipper = require('unzipper');
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

app.use('/app/data/fabric-ca-client', express.static(dynamic_folder));

app.get('/mkdir/:name', (request, response) => {
    const newFolder = path.join(dynamic_folder, request.params.name);
    
    if (!fs.existsSync(newFolder)) {
        fs.mkdirSync(newFolder, { recursive: true });
    }

    response.send('Folder created and exposed');
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