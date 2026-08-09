const REQUIRED_EVIDENCE = ['invoice', 'manager-approval'];
const AUTO_APPROVAL_LIMIT = 5_000;

export function evaluateCase(input) {
  const validationError = validate(input);
  if (validationError) {
    return { ok: false, statusCode: 400, error: validationError };
  }

  const missingEvidence = REQUIRED_EVIDENCE.filter(
    (kind) => !input.evidence.includes(kind),
  );
  const withinLimit = input.requestedAmount <= AUTO_APPROVAL_LIMIT;
  const autoApproved = withinLimit && missingEvidence.length === 0;

  return {
    ok: true,
    statusCode: 200,
    value: {
      caseId: input.caseId,
      status: autoApproved ? 'auto-approved' : 'needs-review',
      reason: autoApproved
        ? 'Required evidence is present and the amount is within policy.'
        : explainReview(withinLimit, missingEvidence),
      citations: buildCitations(input, withinLimit),
      uncertainty: {
        level: autoApproved ? 'low' : withinLimit ? 'medium' : 'high',
        reasons: autoApproved
          ? []
          : [
              ...(!withinLimit ? ['amount exceeds automatic policy authority'] : []),
              ...missingEvidence.map((kind) => `required evidence is missing: ${kind}`),
            ],
      },
    },
  };
}

function validate(input) {
  if (!input || typeof input !== 'object') return 'request body must be an object';
  if (typeof input.caseId !== 'string' || input.caseId.trim() === '') {
    return 'caseId is required';
  }
  if (!Number.isFinite(input.requestedAmount) || input.requestedAmount < 0) {
    return 'requestedAmount must be a non-negative number';
  }
  if (!Array.isArray(input.evidence) || input.evidence.some((item) => typeof item !== 'string')) {
    return 'evidence must be an array of strings';
  }
  return null;
}

function explainReview(withinLimit, missingEvidence) {
  const reasons = [];
  if (!withinLimit) reasons.push('amount exceeds the auto-approval limit');
  if (missingEvidence.length > 0) {
    reasons.push(`missing ${missingEvidence.join(' and ')}`);
  }
  return `${reasons.join('; ')}.`;
}

function buildCitations(input, withinLimit) {
  const citations = input.evidence.map((kind) => `case:${input.caseId}/evidence/${kind}`);
  citations.push(`policy:auto-approval-limit/${withinLimit ? 'within' : 'exceeded'}`);
  return citations;
}
