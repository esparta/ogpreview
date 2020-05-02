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
    console.log(data['ack'])
    theDiv.dataset.id = data['ack']

    poll(function() {
      fetch('/status?ack='+data['ack'])
        .then(handleError)
        .then(response => response.json())
        .then(result => {
          if (result['status'] == 'ready'){
            const oldImage = theDiv.querySelector('#image-result');
            delete theDiv.dataset.id;
            if (oldImage){
              theDiv.removeChild(oldImage);
            }
            theDiv.appendChild(createImage(result['images'][0]));
          }

        })
        .catch(error => console.log(error) );
      return !theDiv.dataset.id
    }, 5000, 250).then(function() {
        console.log('Done');
    }).catch(function() {
          console.log('TimedOut');
    });
  });

  element.addEventListener('ajax:error', () => {
    const [data, _status, _xhr] = event.detail;
    const errors = JSON.stringify(data['errors']);
    var theDiv = document.querySelector('#responses');
    theDiv.innerText = errors;
  });
});


function handleError(response){
  if (!response.ok) {
    throw Error(response.statusText);
  }
  return response;
}

function createImage(src) {
  var theImage = document.createElement('img');
  theImage.setAttribute('src', src);
  theImage.setAttribute('id', 'image-result');
  return theImage;
}
