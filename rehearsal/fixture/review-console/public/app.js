import { evaluateCase } from '/case-client.js';

const form = document.querySelector('#case-form');
const result = document.querySelector('#result');
const disposition = document.querySelector('#disposition');
const dispositionNote = document.querySelector('#disposition-note');

form.addEventListener('submit', async (event) => {
  event.preventDefault();
  const data = new FormData(form);
  const payload = {
    caseId: data.get('caseId'),
    requestedAmount: Number(data.get('requestedAmount')),
    evidence: data.getAll('evidence'),
  };

  result.hidden = false;
  disposition.hidden = true;
  result.textContent = 'Evaluating…';

  try {
    const body = await evaluateCase(payload);
    renderResult(body);
  } catch (error) {
    result.innerHTML = `<h2>Could not evaluate</h2><p>${escapeHtml(error.message)}</p>`;
  }
});

function renderResult(body) {
  const uncertainty = body.uncertainty ?? { level: 'unknown', reasons: ['No assessment returned.'] };
  result.innerHTML = `
    <p class="status">${escapeHtml(body.status)}</p>
    <h2>${escapeHtml(body.caseId)}</h2>
    <p>${escapeHtml(body.reason)}</p>
    <h3>Uncertainty: ${escapeHtml(uncertainty.level)}</h3>
    ${uncertainty.reasons.length ? `<ul>${uncertainty.reasons.map((reason) => `<li>${escapeHtml(reason)}</li>`).join('')}</ul>` : '<p>No unresolved policy checks.</p>'}
    <h3>Evidence trail</h3>
    <ul>${body.citations.map((citation) => `<li><code>${escapeHtml(citation)}</code></li>`).join('')}</ul>
  `;
  disposition.hidden = body.status === 'auto-approved';
}

disposition.addEventListener('click', (event) => {
  const action = event.target.closest('[data-disposition]');
  if (!action) return;
  dispositionNote.textContent = `Local rehearsal decision recorded: ${action.dataset.disposition}.`;
});

function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, (character) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;',
  })[character]);
}
