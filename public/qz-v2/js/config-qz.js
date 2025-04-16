    /// Authentication setup ///
    qz.security.setCertificatePromise(function(resolve, reject) {
        //Preferred method - from server
        fetch("../qz-v2/assets/signing/digital-certificate.txt", {cache: 'no-store', headers: {'Content-Type': 'text/plain'}})
          .then(function(data) { data.ok ? resolve(data.text()) : reject(data.text()); });

        //Alternate method 1 - anonymous
//        resolve();  // remove this line in live environment

    });

    /// Connection ///
    function launchQZ() {
        if (!qz.websocket.isActive()) {
            window.location.assign("qz:launch");
            //Retry 5 times, pausing 1 second between each attempt
            startConnection({ retries: 5, delay: 1 });
        }
    }

    function startConnection(config) {
        var host = $('#connectionHost').val().trim();
        var usingSecure = $("#connectionUsingSecure").prop('checked');

        // Connect to a print-server instance, if specified
        if (host != "" && host != 'localhost') {
            if (config) {
                config.host = host;
                config.usingSecure = usingSecure;
            } else {
                config = { host: host, usingSecure: usingSecure };
            }
        }

        if (!qz.websocket.isActive()) {
            updateState('Waiting', 'default');

            qz.websocket.connect(config).then(function() {
                updateState('Active', 'success');
                findVersion();
            }).catch(handleConnectionError);
        } else {
            displayMessage('An active connection with QZ already exists.', 'alert-warning');
        }
    }

    function endConnection() {
        if (qz.websocket.isActive()) {
            qz.websocket.disconnect().then(function() {
                updateState('Inactive', 'default');
            }).catch(handleConnectionError);
        } else {
            displayMessage('No active connection with QZ exists.', 'alert-warning');
        }
    }


    function listNetworkDevices() {
        var listItems = function(obj) {
            var html = '';
            var labels = { mac: 'MAC', ip: 'IP', up: 'Up', ip4: 'IPv4', ip6: 'IPv6', primary: 'Primary' };

            Object.keys(labels).forEach(function(key) {
                if (!obj.hasOwnProperty(key)) { return; }
                if (key !== 'ip' && obj[key] == obj['ip']) { return; }

                var value = obj[key];
                if (key === 'mac') { value = obj[key].match(/.{1,2}/g).join(':'); }
                if (typeof obj[key] === 'object') { value = value.join(', '); }

                html += '<li><strong>' + labels[key] + ':</strong> <code>' + value + '</code></li>';
            });

            return html;
        };

        qz.networking.devices().then(function(data) {
            var list = '';

            for(var i = 0; i < data.length; i++) {
                var info = data[i];

                if (i == 0) {
                    list += "<li>" +
                        "   <strong>Hostname:</strong> <code>" + info.hostname + "</code>" +
                        "</li>" +
                        "<li>" +
                        "   <strong>Username:</strong> <code>" + info.username + "</code>" +
                        "</li>";
                }
                list += "<li>" +
                    "   <strong>Interface:</strong> <code>" + (info.name || "UNKNOWN") + (info.id ? "</code> (<code>" + info.id + "</code>)" : "</code>") +
                    "   <ul>" + listItems(info) + "</ul>" +
                    "</li>";
            }

            pinMessage("<strong>Network details:</strong><ul>" + list + "</ul>");
        }).catch(displayError);
    }



    /// Page load ///
    $(document).ready(function() {
        window.readingWeight = false;

        startConnection();
    });

    function updateState(text, css) {
        $("#qz-status").html(text);
        $("#qz-connection").removeClass().addClass('panel panel-' + css);

        if (text === "Inactive" || text === "Error") {
            $("#launch").show();
        } else {
            $("#launch").hide();
        }
    }
