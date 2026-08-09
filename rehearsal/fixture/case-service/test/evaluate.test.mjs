import assert from 'node:assert/strict';
import test from 'node:test';
import { evaluateCase } from '../src/evaluate.mjs';

test('auto-approves a complete request within the limit', () => {
  const result = evaluateCase({
    caseId: 'CASE-101',
    requestedAmount: 2_400,
    evidence: ['invoice', 'manager-approval'],
  });

  assert.equal(result.ok, true);
  assert.equal(result.value.status, 'auto-approved');
  assert.ok(result.value.citations.length > 0);
});

test('routes an incomplete request to review', () => {
  const result = evaluateCase({
    caseId: 'CASE-102',
    requestedAmount: 900,
    evidence: ['invoice'],
  });

  assert.equal(result.value.status, 'needs-review');
  assert.match(result.value.reason, /manager-approval/);
});

test('rejects malformed input', () => {
  const result = evaluateCase({ caseId: '', requestedAmount: -1, evidence: [] });
  assert.equal(result.ok, false);
  assert.equal(result.statusCode, 400);
});
