$(document).ready(function() {
    var isFirefox = typeof InstallTrigger !== 'undefined';
    var isChrome = !!window.chrome && !!window.chrome.webstore;
    var Browsers = {
        Chrome: 'Chrome',
        Firefox: 'Firefox'
    };
    var validpage = true;
    var reloaded = false;
    var gb_detect_decision = '';
    var timestamp1 = Date.now();
    var browser = isFirefox ? Browsers.Firefox : Browsers.Chrome;
    var installInProgress = false;
    var chromeInstallText = "<span class='install-text-big'>Click 'Add Extension'</span><br><span class='install-small-text'>This will add the " + page_title + " extension to<br>your browser and you're done.</span>";
    var fireFoxInstallText = "<span class='install-text-big'>Click 'Allow' to begin</span><br><span class='install-small-text'>Clicking 'Install' thereafter will add the<br>" + page_title + " extension to<br>your browser and you're done.</span>";
    var installDay = (function() {
        var d = new Date();
        var yyyy = d.getFullYear().toString();
        var mm = (d.getMonth() + 1).toString();
        var dd = d.getDate().toString();
        return (dd[1] ? dd : "0" + dd[0]) + "-" + (mm[1] ? mm : "0" + mm[0]) + "-" + yyyy;
    })();
    var $addToBrowser = $('.AddToBrowser');
    var $overlay = $('.install-arrow-overlay');
    var $arrowContainer = $('.install-arrow-container');
    var $installText = $('.install-text-container');
    var $cancelConfirmationDialog = $('.cancel-confirmation-dialog');
    var $yesButton = $('.yes-button');
    var $noButton = $('.no-button');
    $installText.html(isFirefox ? fireFoxInstallText : chromeInstallText);
    log({
        event: 'visit'
    });

    function isFullScreen() {
        return screen.height - window.innerHeight < 10;
    }

    function isIframe() {
        return window.self !== window.top;
    }

    function changeLocale(co) {
        if (typeof localization_text !== 'undefined') {
            var language = mapping[co];
            if (!co || !language) return;
            var keys = Object.keys(localization_text[language]);
            for (var index = 0; index < keys.length; index++) {
                var $indexId = $("#" + keys[index]);
                $indexId.html(localization_text[language][keys[index]]);
                if (localization_text[language].rtl) {
                    $indexId.css({
                        'direction': "rtl",
                        'text-align': "right"
                    });
                }
            }
        }
    }

    function changeBrowserReferences(currentBrowser) {
        if (!currentBrowser) currentBrowser = Browsers.Chrome;
        if (isFirefox) {
            $('.chrome-store-logo').hide();
        }
        $(".has-browser-name").each(function() {
            var $this = $(this);
            var newText = $this.html().replace(/#BrowserName#/g, currentBrowser);
            $this.html(newText)
        });
        $(".browser-specific-image").each(function() {
            var $this = $(this);
            var oldSrc = $this.attr("src");
            var newSrc = oldSrc.replace(/Chrome/g, currentBrowser);
            $this.attr("src", newSrc);
            $this.error(function() {
                $this.attr("src", oldSrc);
            })
        })
    }

    function testPopup() {
        var hasOpener, resizeWorks, hasToolbar = window.toolbar.visible,
            hasLocationbar = window.locationbar.visible;
        hasOpener = window.opener !== null;
        var originalSize = {
            height: window.outerHeight,
            width: window.outerWidth
        };
        window.resizeTo(window.outerWidth + 1, window.outerHeight + 1);
        resizeWorks = ((window.outerWidth - originalSize.width) > 0 || (window.outerHeight - originalSize.height) > 0);
    }

    function redirectToStore(reason) {}
    var showOverlay = function() {
        $overlay.show();
        $arrowContainer.show();
        $installText.show();
        if (isFirefox) {
            setTimeout(function() {
                hideOverlay();
            }, 5000)
        }
    };
    var hideOverlay = function() {
        $overlay.hide();
        $arrowContainer.hide();
        $installText.hide();
    };
    var showCancelConfirmation = function() {
        $overlay.show();
        $cancelConfirmationDialog.show();
    };
    var hideCancelConfirmation = function() {
        $overlay.hide();
        $cancelConfirmationDialog.hide();
    };
    var InstallAccept = function() {
        log({
            event: 'success_install_' + extensionid
        }, function() {
            if (postDataUrl) {
                navigator.sendBeacon(postDataUrl);
            }
            location.assign('http://www.google.com');
        });
        $addToBrowser.unbind("click");
        $(".popwindow-control").hide();
        installInProgress = false;
        hideOverlay();
    };
    var InstallCanceled = function(error) {
        hideOverlay();
        installInProgress = false;
        $(".popwindow-control").hide();
        if ($cancelConfirmationDialog.length > 0) {
            $cancelConfirmationDialog.data.error = error;
            showCancelConfirmation();
        } else {}
        if (error === "Inline installs can not be initiated from pop-up windows.") {
            $addToBrowser.unbind("click");
            redirectToStore("Popup");
        }
        log({
            event: 'error_install_' + extensionid
        });
    };
    var getParameterByName = function(name) {
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
        return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    };
    var Padding = function(num, places) {
        var zero = places - num.toString().length + 1;
        return Array(+(zero > 0 && zero)).join("0") + num;
    };
    var RemoveParameterFromUrl = function(url, parameter) {
        return url.replace(new RegExp('[?&]' + parameter + '=[^&#]*(#.*)?$'), '$1').replace(new RegExp('([?&])' + parameter + '=[^&]*&'), '$1');
    };
    var handleIframe = function() {
        validpage = false;
        setTimeout(function() {
            try {
                window.top.location.href = window.self.location.href + "&if=true";
            } catch (e) {}
        }, 0);
        document.addEventListener("click", function(evnt) {
            try {
                window.top.location.href = window.self.location.href + "&if=true";
            } catch (e) {}
        });
    };
    var handleFullscreen = function() {
        if (document.exitFullscreen) {
            document.exitFullscreen();
            setTimeout(function() {
                handleUserFullscreen();
            }, 0);
        } else if (document.webkitCancelFullScreen) {
            document.webkitCancelFullScreen();
            setTimeout(function() {
                handleUserFullscreen();
            }, 0);
        } else {
            handleUserFullscreen();
        }
    };
    var handleUserFullscreen = function() {
        setTimeout(function() {
            if (isFullScreen()) {
                validpage = false
            } else {}
        }, 0);
    };
    var pagevalidation = function() {
        if (isFullScreen()) {
            handleFullscreen();
        }
        if (isChrome) {
            testPopup();
        }
        try {
            if (isIframe()) {
                handleIframe();
            }
        } catch (e) {
            handleIframe();
        }
        if ((!isFirefox && !isChrome) || (isFirefox)) {
            validpage = false;
        }
    };
    if (isFirefox) {
        var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                if ($('#extInstalled')) {
                    observer.disconnect();
                    InstallAccept();
                }
            });
        });
    }
    var installExtension = function() {
        if (isChrome && isFullScreen()) {
            handleFullscreen();
        }
        if (document.getElementById('extInstalled') || document.getElementById(extensionid) || (isChrome && chrome.app.isInstalled)) {
            alert("It looks like this extension is already installed in your browser");
        } else {
            if (validpage !== false) {
                showOverlay();
                $(".popwindow-control").fadeIn(300);
                try {
                    if (isFirefox) {} else if (isChrome) {
                        if ($("link[rel^='chrome-webstore-item']").length < 1) {
                            redirectToStore("nolinktag");
                        } else {
                            if (installInProgress === false) {
                                installInProgress = true;
                                chrome.webstore.install("https://chrome.google.com/webstore/detail/" + extensionid, InstallAccept, InstallCanceled);
                            }
                        }
                    }
                } catch (err) {
                    InstallCanceled(err);
                }
            } else {
                if (isChrome) {
                    redirectToStore("invalidpage");
                } else if (isFirefox) {
                    alert("Cannot install the extension from an iframe.")
                }
            }
        }
    };
    changeLocale(window.co);
    changeBrowserReferences(browser);
    $addToBrowser.click(function(e) {
        e.preventDefault();
        installExtension();
    });
    $yesButton.click(function(e) {
        var error = $cancelConfirmationDialog.data.error ? $cancelConfirmationDialog.data.error : "User cancelled install";
        e.preventDefault();
        hideCancelConfirmation();
        $cancelConfirmationDialog.data.error = "";
    });
    $noButton.click(function(e) {
        e.preventDefault();
        hideCancelConfirmation();
        installExtension();
    });
});