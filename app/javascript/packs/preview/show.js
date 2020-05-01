window.addEventListener('load', () => {
  const element = document.querySelector('#new-preview');
  element.addEventListener('ajax:success', (event) => {
    var theDiv = document.querySelector('#responses');
    const [data, _status, _xhr] = event.detail;
    const message = 'Preview has been submitted';

    theDiv.insertAdjacentHTML('beforeend', message);
  });

  element.addEventListener('ajax:error', () => {
    element.insertAdjacentHTML('beforeend', '<p>ERROR</p>');
  });
});
