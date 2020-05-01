window.addEventListener('load', () => {
  const element = document.querySelector('#new-preview');
  element.addEventListener('ajax:success', (event) => {
    var theDiv = document.querySelector('#responses');
    const [data, _status, _xhr] = event.detail;
    theDiv.dataset.id = data['ack']

    fetch('/status?ack='+data['ack'])
      .then(handleError)
      .then(response => response.json())
      .then(result => {
        console.log(result)
        r = result['data'];
        delete theDiv.dataset.id;
        const oldImage = theDiv.querySelector('#image-result');
        if (oldImage){
          theDiv.removeChild(oldImage);
        }
        theDiv.appendChild(createImage(result['images'][0]));
      })
      .catch(error => console.log(error) );
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
  console.log(src)
  var theImage = document.createElement('img');
  theImage.setAttribute('src', src);
  theImage.setAttribute('id', 'image-result');
  return theImage;
}
