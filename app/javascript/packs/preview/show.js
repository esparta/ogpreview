// https://davidwalsh.name/javascript-polling
function poll(fn, timeout, interval){
    var endTime = Number(new Date()) + (timeout || 2000);

    interval = interval || 100;
    var checkCondition = function(resolve, reject){
      // if the condition if met, we're done
      var result = fn();
      if (result) {
          resolve(result);
        }
      // if the condition isn't met but the timeout hasn't elapsed, go again
      else if (Number(new Date()) < endTime) {
          setTimeout(checkCondition, interval, resolve, reject);
        }
      // Didn't match and too much time, reject!
      else {
          reject(new Error('timed out for ' + fn + ': ' + arguments));
        }
    };
  return new Promise(checkCondition);
}

window.addEventListener('load', () => {
  const element = document.querySelector('#new-preview');
  element.addEventListener('ajax:success', (event) => {
    var theDiv = document.querySelector('#responses');
    const [data, _status, _xhr] = event.detail;
    theDiv.dataset.id = data['ack']

    removeImage(theDiv);
    setErrorDiv('invisible');
    var theSpinner = document.querySelector('#spinner-section');
    theSpinner.setAttribute('class', 'visible');
    var theMessage = document.querySelector('#message');
    poll(function() {
      fetch('/status?ack='+data['ack'])
        .then(handleError)
        .then(response => response.json())
        .then(result => {
          switch(result['status']) {
            case 'error':
              delete theDiv.dataset.id;
              displayError('Error while processing OpenGraph');
              break;
            case 'ready':
              delete theDiv.dataset.id;
              removeImage(theDiv);
              theDiv.appendChild(createImage(result['images'][0]));
              break;
            default:
              theMessage.innerHTML = result['status'];
          }
        })
        .catch(error => console.log(error) );
      return !theDiv.dataset.id
    }, 5000, 250).then(function() {
      theSpinner.setAttribute('class', 'invisible');
        theMessage.innerHTML = '';
    }).catch(function() {
        theMessage.innerHTML = 'Timed Out';
    });
  });

  element.addEventListener('ajax:error', () => {
    const [data, _status, _xhr] = event.detail;
    const errors = JSON.stringify(data['errors']);
    const responseDiv = document.querySelector('#responses');
    removeImage(responseDiv);
    displayError(errors);
  });
});


function handleError(response){
  if (!response.ok) {
    throw Error(response.statusText);
  }
  return response;
}

function displayError(message){
  var theDiv = document.querySelector('#errors');
  theDiv.innerText = 'An error has occur: ' + message;
  setErrorDiv('visible');
}

function setErrorDiv(visibility){
  var errorDiv = document.querySelector('#error-div');
  errorDiv.setAttribute('class', visibility);
}

function removeImage(theDiv){
  const oldImage = theDiv.querySelector('#image-result');
  if (oldImage){
    theDiv.removeChild(oldImage);
  }
}

function createImage(src) {
  var theFigure = document.createElement('figure');
  theFigure.setAttribute('class', 'figure');
  theFigure.setAttribute('id', 'image-result');
  var theImage = document.createElement('img');
  if (src) {
    theImage.setAttribute('src', src);
  }
  else{
    theImage.setAttribute('src', 'product_image_not_found.gif');
  }

  theImage.setAttribute('class', 'figure-img img-fluid rounded');
  theFigure.appendChild(theImage);
  return theFigure;
}
