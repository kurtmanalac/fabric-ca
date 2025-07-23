const express = require('express');
const fs = require('fs').promises;
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

app.post('/copy-msp', async (request, response) => {
    const { sourcePath, destinationPath } = request.body;

    if (!sourcePath || !destinationPath) {
        return response.status(400).json({ error: 'Source and destination paths are required.' });
    }

    try {
        // Ensure the destination directory exists
        await fs.mkdir(destinationPath, { recursive: true });

        // Use fs.cp for recursive folder copying (Node.js v16+)
        await fs.cp(sourcePath, destinationPath, { recursive: true });

        response.status(200).json({ message: 'Folder copied successfully!' });
    } catch (error) {
        console.error('Error copying folder:', error);
        response.status(500).json({ error: 'Failed to copy folder.' });
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