window.addEventListener('load', () => {
  const element = document.querySelector('#new-preview');
  element.addEventListener('ajax:success', (event) => {
    var theDiv = document.querySelector('#responses');
    const [data, _status, _xhr] = event.detail;
    const message = 'Preview has been submitted: ' + data['ack'];
    theDiv.dataset.id = data['ack']
    theDiv.innerText = message;
  });

  element.addEventListener('ajax:error', () => {
    const [data, _status, _xhr] = event.detail;
    const errors = JSON.stringify(data['errors']);
    var theDiv = document.querySelector('#responses');
    theDiv.innerText = errors;
  });
});
