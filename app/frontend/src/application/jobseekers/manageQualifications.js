export const DELETE_BUTTON_CLASSNAME = 'delete-button';
export const FIELDSET_ID = 'subjects-and-grades';
export const GOVUK_ERROR_MESSAGE_CLASSNAME = '.govuk-error-message';
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
        manageQualifications.addDeletionEventListener(row);
      }
    });
  }
});

export const addEventListenerForAddSubject = (link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    manageQualifications.addSubject();
  });
};

export const addSubject = () => {
  const newRow = rowMarkup().cloneNode(true);

  document.getElementById(FIELDSET_ID).appendChild(newRow);
  const numberRows = rows().length;
  manageQualifications.insertDeleteButton(newRow, numberRows);
  manageQualifications.renumberRow(newRow, numberRows, false, false);
  newRow.querySelector(GOVUK_INPUT_SELECTOR).focus();
};

export const insertDeleteButton = (row, newNumber) => {
  row.insertAdjacentHTML('beforeend', `<a id="delete_${newNumber}"
    class="govuk-link ${DELETE_BUTTON_CLASSNAME} govuk-!-margin-bottom-6 govuk-!-padding-bottom-2"
    rel="nofollow"
    href="#">delete subject</a>`);
  manageQualifications.addDeletionEventListener(row);
};

export const addDeletionEventListener = (row) => {
  row.querySelector(`.${DELETE_BUTTON_CLASSNAME}`).addEventListener('click', (event) => {
    event.preventDefault();
    manageQualifications.onDelete(event.target.id.replace(/\D/g, ''));
  });
};

export const onDelete = (indexToDelete) => {
  document.getElementById(`subject_row_${indexToDelete}`).remove();
  manageQualifications.renumberRemainingRows(indexToDelete);
};

export const renumberRemainingRows = (deletedIndex) => {
  Array.from(manageQualifications.rows()).forEach((row, index) => {
    if (index >= deletedIndex - 1) {
      manageQualifications.renumberRow(row, index + 1, true, true);
    }
  });
};

export const renumberRow = (row, newNumber, keepValues, keepErrors) => {
  row.id = `subject_row_${newNumber}`;
  Array.from(row.children).forEach((column) => manageQualifications.renumberColumn(column, newNumber, keepValues, keepErrors));
};

export const renumberColumn = (column, newNumber, keepValues, keepErrors) => {
  let input = column.querySelector(GOVUK_INPUT_SELECTOR);
  let inputValue;
  if (input && keepValues) {
    inputValue = input.value;
  }
  column.id = column.id.replace(/\d+/g, `${newNumber}`);
  column.innerHTML = column.innerHTML.replace(/\d+/g, `${newNumber}`);
  if (!keepErrors && column.querySelector(GOVUK_ERROR_MESSAGE_CLASSNAME)) {
    manageQualifications.removeErrors(column);
  }
  input = column.querySelector(GOVUK_INPUT_SELECTOR);
  if (input) {
    if (inputValue && keepValues) {
      input.value = inputValue;
    } else {
      input.removeAttribute('value');
      input.removeAttribute('aria-required');
    }
  }
};

export const removeErrors = (column) => {
  column.className = column.className.replace(/\bgovuk-form-group--error\b/g, '');
  column.innerHTML = column.innerHTML.replace(/field-error\b/g, 'field');
  column.innerHTML = column.innerHTML.replace(/govuk-input--error\b/g, '');
  column.querySelector(GOVUK_ERROR_MESSAGE_CLASSNAME).remove();
  column.querySelector(GOVUK_INPUT_SELECTOR).removeAttribute('aria-describedby');
};

const manageQualifications = {
  addDeletionEventListener,
  addEventListenerForAddSubject,
  addSubject,
  FIELDSET_ID,
  insertDeleteButton,
  onDelete,
  removeErrors,
  renumberColumn,
  renumberRemainingRows,
  renumberRow,
  ROW_CLASS,
  rows,
  SUBJECT_LINK_ID,
};

export default manageQualifications;
