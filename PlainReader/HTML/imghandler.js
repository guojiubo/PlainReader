function handleImgs () {
    var custonPrefix = 'plainreader://article.body.img?';
    
    var imgOnClick = function() {
        if (this.src.indexOf(custonPrefix) != -1) {
            this.src = this.src.replace(custonPrefix, '')
        }
        this.removeEventListener('click', imgOnClick)
    };
    
    var imgs = document.getElementsByTagName('img');
    for (var i = imgs.length - 1; i >= 0; i--) {
        var img = imgs[i];
        if (img.parentNode.tagName.toLowerCase() == 'a') {
            if (img.src.indexOf(custonPrefix) != -1) {
                img.parentNode.href = img.src;
                img.addEventListener('click', imgOnClick);
            } else {
                img.parentNode.href = custonPrefix + img.src;
            }
        } else {
            var a = document.createElement('a');
            var dupNode = img.cloneNode(true);
            if (dupNode.src.indexOf(custonPrefix) != -1) {
                a.href = dupNode.src;
                dupNode.addEventListener('click', imgOnClick);
            } else {
                a.href = custonPrefix + dupNode.src;
            }
            a.appendChild(dupNode);
            img.parentNode.replaceChild(a, img);
        }
    };
}