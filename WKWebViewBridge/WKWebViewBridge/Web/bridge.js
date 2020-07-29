// 모바일 에이전트 구분
var isMobile = {
    Android: function () {
        return navigator.userAgent.match(/Android/i) == null ? false : true;
    },
    iOS: function () {
        return navigator.userAgent.match(/iPhone|iPad|iPod/i) == null ? false : true;
    },
    any: function () {
        return (isMobile.Android() || isMobile.iOS());
    }
};

// 본문 영역 링크 클릭 시 
function outLink(link) {
    if (isMobile.any()) {
        if (isMobile.Android()) {
            android.bridge.outLink(link);
        } else if (isMobile.iOS()) {
            webkit.messageHandlers.outLink.postMessage(link);
        }
    }
}	

// Back Button 클릭
function back() {
    if (isMobile.any()) {
        if (isMobile.Android()) {
            android.bridge.back(true);
        } else if (isMobile.iOS()) {
            webkit.messageHandlers.back.postMessage(true);
        }
    }
}
