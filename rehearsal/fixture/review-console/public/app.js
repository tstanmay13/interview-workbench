const form = document.querySelector('#case-form');
const result = document.querySelector('#result');

form.addEventListener('submit', async (event) => {
  event.preventDefault();
  const data = new FormData(form);
  const payload = {
    caseId: data.get('caseId'),
    requestedAmount: Number(data.get('requestedAmount')),
    evidence: data.getAll('evidence'),
  };

  result.hidden = false;
  result.textContent = 'Evaluating…';

  try {
    const response = await fetch('http://127.0.0.1:4100/evaluate', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify(payload),
    });
    const body = await response.json();
    if (!response.ok) throw new Error(body.error ?? 'Evaluation failed');
    renderResult(body);
  } catch (error) {
    result.innerHTML = `<h2>Could not evaluate</h2><p>${escapeHtml(error.message)}</p>`;
  }
});

function renderResult(body) {
  result.innerHTML = `
    <p class="status">${escapeHtml(body.status)}</p>
    <h2>${escapeHtml(body.caseId)}</h2>
    <p>${escapeHtml(body.reason)}</p>
    <h3>Evidence trail</h3>
    <ul>${body.citations.map((citation) => `<li><code>${escapeHtml(citation)}</code></li>`).join('')}</ul>
  `;
}

function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, (character) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;',
  })[character]);
}
