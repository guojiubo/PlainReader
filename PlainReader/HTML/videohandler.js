/*
 *  This file should be compressd and placed in the server instead of archiving
 *  directly in App bundle, so that you can update it when needed.
 */
function handleVideos() {
    var embeds = document.getElementsByTagName('embed');
    for (var i = embeds.length - 1; i >= 0; i--) {
        var embed = embeds[i];
        var src = embed.src;
        if (src.indexOf('sohu.com') > -1) {
            var m = src.match(/\Wid=(\w+)/i);
            if (m) {
                var id = m[1];
                var video = document.createElement('video');
                video.setAttribute('controls', true);
                var m3u8 = 'http://my.tv.sohu.com/ipad/' + id + '.m3u8';
                video.src = m3u8;
                embed.parentNode.replaceChild(video, embed)
            } else {
                var div = createVideoPlaceholder();
                embed.parentNode.replaceChild(div, embed)
            }
        } else if (src.indexOf('youku.com') > -1) {
            var m = src.match(/sid\/(\w+)/i);
            if (m) {
                var id = m[1];
                var iframe = document.createElement('iframe');
                var m3u8 = 'http://player.youku.com/embed/' + id;
                iframe.src = m3u8;
                embed.parentNode.replaceChild(iframe, embed)
            } else {
                var div = createVideoPlaceholder();
                embed.parentNode.replaceChild(div, embed)
            }
        } else if (src.indexOf('tudou.com') > -1) {
            var m = src.match(/\/v\/(\w+)/i);
            if (m) {
                var id = m[1];
                var iframe = document.createElement('iframe');
                var m3u8 = 'http://www.tudou.com/programs/view/html5embed.action?code=' + id;
                iframe.src = m3u8;
                embed.parentNode.replaceChild(iframe, embed)
            } else {
                var div = createVideoPlaceholder();
                embed.parentNode.replaceChild(div, embed)
            }
        } else {
            var div = createVideoPlaceholder();
            embed.parentNode.replaceChild(div, embed)
        }
    }
    
    function createVideoPlaceholder() {
        var div = document.createElement('div');
        div.class = 'videoPlaceholder';
        var forbidden = document.createElement('div');
        forbidden.class = 'videoForbidden';
        div.appendChild(icon);
        return div
    }
}