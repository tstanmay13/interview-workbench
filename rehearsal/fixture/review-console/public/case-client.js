export async function evaluateCase(payload, options = {}) {
  const baseUrl = options.baseUrl ?? 'http://127.0.0.1:4100';
  const fetchImpl = options.fetchImpl ?? globalThis.fetch;
  const response = await fetchImpl(`${baseUrl}/evaluate`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify(payload),
  });
  const body = await response.json();
  if (!response.ok) {
    const error = new Error(body.error ?? 'Evaluation failed');
    error.statusCode = response.status;
    throw error;
  }
  return body;
}
