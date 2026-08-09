import { createServer } from 'node:http';
import { evaluateCase } from './src/evaluate.mjs';

const port = Number(process.env.PORT ?? 4100);

const server = createServer(async (request, response) => {
  setCors(response);

  if (request.method === 'OPTIONS') {
    response.writeHead(204).end();
    return;
  }

  if (request.method === 'GET' && request.url === '/health') {
    sendJson(response, 200, { status: 'ok' });
    return;
  }

  if (request.method === 'POST' && request.url === '/evaluate') {
    try {
      const input = JSON.parse(await readBody(request));
      const result = evaluateCase(input);
      sendJson(response, result.statusCode, result.ok ? result.value : { error: result.error });
    } catch (error) {
      const message = error instanceof SyntaxError ? 'request body must be valid JSON' : 'request failed';
      sendJson(response, 400, { error: message });
    }
    return;
  }

  sendJson(response, 404, { error: 'not found' });
});

server.listen(port, '127.0.0.1', () => {
  console.log(`case-service listening on http://127.0.0.1:${port}`);
});

function readBody(request) {
  return new Promise((resolve, reject) => {
    let body = '';
    request.setEncoding('utf8');
    request.on('data', (chunk) => {
      body += chunk;
      if (body.length > 1_000_000) reject(new Error('request too large'));
    });
    request.on('end', () => resolve(body));
    request.on('error', reject);
  });
}

function setCors(response) {
  response.setHeader('access-control-allow-origin', '*');
  response.setHeader('access-control-allow-headers', 'content-type');
  response.setHeader('access-control-allow-methods', 'GET, POST, OPTIONS');
}

function sendJson(response, statusCode, body) {
  response.writeHead(statusCode, { 'content-type': 'application/json; charset=utf-8' });
  response.end(JSON.stringify(body));
}
