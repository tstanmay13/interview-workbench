import { createReadStream } from 'node:fs';
import { stat } from 'node:fs/promises';
import { createServer } from 'node:http';
import { extname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const publicDirectory = fileURLToPath(new URL('./public/', import.meta.url));
const port = Number(process.env.PORT ?? 4200);
const contentTypes = {
  '.css': 'text/css; charset=utf-8',
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
};

createServer(async (request, response) => {
  const pathname = request.url === '/' ? '/index.html' : new URL(request.url, 'http://localhost').pathname;
  const safePath = pathname.replace(/^\/+/, '');
  const filePath = join(publicDirectory, safePath);

  if (!filePath.startsWith(publicDirectory)) {
    response.writeHead(403).end('forbidden');
    return;
  }

  try {
    const file = await stat(filePath);
    if (!file.isFile()) throw new Error('not a file');
    response.writeHead(200, { 'content-type': contentTypes[extname(filePath)] ?? 'application/octet-stream' });
    createReadStream(filePath).pipe(response);
  } catch {
    response.writeHead(404, { 'content-type': 'text/plain; charset=utf-8' }).end('not found');
  }
}).listen(port, '127.0.0.1', () => {
  console.log(`review-console listening on http://127.0.0.1:${port}`);
});
