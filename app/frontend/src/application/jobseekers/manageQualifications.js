export const DELETE_BUTTON_CLASSNAME = 'delete-button';
export const FIELDSET_CLASSNAME = 'subjects-and-grades';
export const GOVUK_ERROR_MESSAGE_SELECTOR = '.govuk-error-message';
export const GOVUK_INPUT_SELECTOR = '.govuk-input';
export const ROW_CLASS = 'subject-row';
export const SUBJECT_LINK_ID = 'add_subject';

export const rows = () => document.getElementsByClassName(ROW_CLASS);
export const rowMarkup = () => rows()[0];

window.addEventListener('DOMContentLoaded', () => {
  const subjectLink = document.getElementById(SUBJECT_LINK_ID);
  if (subjectLink) {
    manageQualifications.addEventListenerForAddSubject(subjectLink);
    Array.from(manageQualifications.rows()).forEach((row, index) => {
      if (index > 0) {
        manageQualifications.addDeletionEventListener(row.querySelector(`.${DELETE_BUTTON_CLASSNAME}`));
      }
    });
  }
});

export const addEventListenerForAddSubject = (el) => {
  el.addEventListener('click', (event) => {
    event.preventDefault();
    manageQualifications.addSubject();
  });
};

export const addSubject = () => {
  const newRow = rowMarkup().cloneNode(true);
  document.getElementsByClassName(FIELDSET_CLASSNAME)[0].appendChild(newRow);
  const numberRows = rows().length;
  manageQualifications.insertDeleteButton(newRow, numberRows);
  manageQualifications.renumberRow(newRow, numberRows, true);
  newRow.querySelector(GOVUK_INPUT_SELECTOR).focus();
};

export const insertDeleteButton = (row, newNumber) => {
  row.insertAdjacentHTML('beforeend', `<a id="delete_${newNumber}"
    class="govuk-link ${DELETE_BUTTON_CLASSNAME} govuk-!-margin-bottom-6 govuk-!-padding-bottom-2"
    rel="nofollow"
    href="#">delete subject</a>`);
  manageQualifications.addDeletionEventListener(row.querySelector(`.${DELETE_BUTTON_CLASSNAME}`));
};

export const addDeletionEventListener = (el) => {
  el.addEventListener('click', (event) => {
    event.preventDefault();
    manageQualifications.onDelete(event.target);
  });
};

export const onDelete = (eventTarget) => {
  eventTarget.parentNode.remove();
  manageQualifications.renumberRows();
};

export const renumberRows = () => Array.from(manageQualifications.rows()).forEach((row, index) => manageQualifications.renumberRow(row, index + 1));

export const renumberRow = (row, newNumber, clearValues) => {
  Array.from(row.children).forEach((column) => Array.from(column.children).forEach((cellEl) => {
    manageQualifications.renumberCell(cellEl, newNumber, clearValues);
  }));
};

export const renumberCell = (renumberEl, newNumber, clearValues) => {
  renumberEl.innerHTML = renumberEl.innerHTML.replace(/\d+/g, `${newNumber}`);

  Array.from(renumberEl.attributes).forEach((attribute) => {
    if (clearValues) {
      if (renumberEl.parentNode.querySelector(GOVUK_ERROR_MESSAGE_SELECTOR)) {
        manageQualifications.removeErrors(renumberEl.parentNode);
      }

      renumberEl.removeAttribute('value');
      renumberEl.removeAttribute('aria-required');
    }

    renumberEl.setAttribute(attribute.name, attribute.value.replace(/\d+/g, `${newNumber}`));
  });
};

export const removeErrors = (column) => {
  column.className = column.className.replace(/\bgovuk-form-group--error\b/g, '');
  column.innerHTML = column.innerHTML.replace(/field-error\b/g, 'field');
  column.innerHTML = column.innerHTML.replace(/govuk-input--error\b/g, '');
  column.querySelector(GOVUK_ERROR_MESSAGE_SELECTOR).remove();
  column.querySelector(GOVUK_INPUT_SELECTOR).removeAttribute('aria-describedby');
};

const manageQualifications = {
  addDeletionEventListener,
  addEventListenerForAddSubject,
  addSubject,
  insertDeleteButton,
  onDelete,
  removeErrors,
  renumberCell,
  renumberRows,
  renumberRow,
  rows,
  DELETE_BUTTON_CLASSNAME,
  FIELDSET_CLASSNAME,
  ROW_CLASS,
  SUBJECT_LINK_ID,
};

export default manageQualifications;
