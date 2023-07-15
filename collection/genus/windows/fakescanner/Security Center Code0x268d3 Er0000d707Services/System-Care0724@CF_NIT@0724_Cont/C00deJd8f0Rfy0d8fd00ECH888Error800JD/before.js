window.addEventListener("beforeunload", function (e) {
         var confirmationMessage = 'It looks like you have been editing something. '
                            + 'If you leave before saving, your changes will be lost.';

                (e || window.event).returnValue = confirmationMessage; 
                return confirmationMessage;
            });