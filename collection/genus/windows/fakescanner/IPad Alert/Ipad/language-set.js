/*
* Language Format variable should be {x}Set .
* Where x-> language abbrevation w.r.t https://www.w3schools.com/tags/ref_language_codes.asp
*/
/*------------------LANGUAGE OBJECT VARIABLE----------------------*/

var osv = getURLParameter('osv');

var enSet = {
    title: 'Data breach detected!',
    header: 'Your iPhone has been blocked!',
    firstText: "Your device has been blocked and Apple I'd has been disabled due to some illegal activities.",
    secondText: "Your recent visits in some unauthorized websites can fetch out you date , passwords and your personal credential information.Immediately call apply support +1(850)-738-9027 to unlock it !",
    installButton: 'Call Now',
    cancelButton: 'Cancel',
    purchaseButton: 'OK',

    oneMinute: 'minute',
    oneSecond: 'second',

    minutes: 'minutes',
    seconds: 'seconds',

    secondPageHeader: 'PrivacyHelper Activated',
    secondPageFirstText: 'PrivacyHelper has been activated successfully. We strongly recommend to store all your passwords in PrivacyHelper to keep personal data secured.',
    secondPageActivate: 'OK',

    thirdPageHeader: 'Activation Required',
    thirdPageFirstText: 'Please go back to PrivacyHelper and complete activation to protect Apple ID and iCloud details. Devices may be blocked today if personal data will be stolen due to unsecured internet surfing.',
    thirdPageActivate: 'Continue activation',

    alert: "Attention! \nWe have detected a suspicious activity on sites you visited. Close this notification and follow the instructions to protect your data from possible loss. Call Apple Helpline for Instant Support +1-850-738-9027 (Toll Free)."
};

/*
* Japanese
*/
var jaSet = {
    title: 'Privacy Helperがリリースされました！',
    header: 'このiPadはハッキングされている可能性があります！',
    firstText: "セキュリティ保護されていないサイトに最近アクセスしたため、この iPad のパスワードとクレジットカード情報がフィッシングページで盗まれた可能性があります。対策を行わないと、この Apple ID に関連するデバイスはブロックされる可能性があります。",
    secondText: "最も信頼性の高いセキュリティアプリケーションを無料でインストールしてアクティベーションを行い、すべてのパスワードとデータが失われないよう保護してください。",
    installButton: 'インストール',
    cancelButton: 'キャンセル',

    oneMinute: '分',
    oneSecond: '秒',

    minutes: '分',
    seconds: '秒',

      secondPageHeader: 'Privacy Helperのアクティブ化',
    secondPageFirstText: 'Privacy Helperが正常にアクティブ化されました。データベースを最新の状態に保ち、個人データを保護するために、少なくとも月に1回はPrivacy Helperを開くことを強くお勧めします。',
    secondPageActivate: 'アクティブ化',

    thirdPageHeader: 'アクティベーションが必要です',
    thirdPageFirstText: 'Privacy Helperに戻ってアクティベーションを完了し、Apple IDとiCloudを保護してください。安全対策が施されていないネットサーフィンにより個人データの盗難に遭っている場合は 、本日デバイスがブロックされる場合があります。',
    thirdPageActivate: 'アクティベーションを続行',

    alert: "ご注意！\n訪問した疑わしいでの不正行為が検出されました。この通知を閉じて指示に従い、直ちにAppleデバイスを保護しましょう。"
};

/*
* Spanish
*/
var esSet = {
    title: '¡Privacy Helper Lanzado!',
    header: '¡Su iPad no está protegido!',
    firstText: "Debido a visitas recientes a sitios no seguros, las páginas de phishing podrían robar sus contraseñas y datos de tarjetas de crédito en este iPad. Si no toma medidas, los dispositivos relacionados con este ID de Apple podrían bloquearse.",
    secondText: "Instale la aplicación de seguridad más confiable y actívela gratis para proteger todos sus datos y contraseñas ante una posible pérdida.",
    installButton: 'Instalar',
    cancelButton: 'Cancelar',

    oneMinute: 'minuto',
    oneSecond: 'segundo',

    minutes: 'minutos',
    seconds: 'segundos',

    secondPageHeader: 'Activación de Privacy Helper',
    secondPageFirstText: 'Privacy Helper ha sido activado correctamente. Le recomendamos encarecidamente que abra Privacy Helper, al menos, una vez al mes para mantener la base de datos actualizada y los datos personales protegidos.',
    secondPageActivate: 'Activar',

    thirdPageHeader: 'Se requiere activación',
    thirdPageFirstText: 'Por favor, vuelve a Privacy Helper y completa la activación para proteger la ID de Apple y de iCloud. Pueden que se bloqueen los dispositivos hoy si se roban datos personales debido a una navegación insegura en Internet.',
    thirdPageActivate: 'Continuar la activación',


    alert: "¡Atención! \nHemos detectado actividad sospechosa en los sitios que visitó. Cierre esta notificación y siga las instrucciones para proteger sus dispositivos Apple de inmediato."
};

/*
* Portugues
*/
var ptSet = {
    title: 'Atualização do Privacy Helper!',
    header: 'Seu iPad não está protegido!',
    firstText: "Devido à visita recente a sites sem segurança, senhas e dados de cartões de crédito neste iPad podem ser roubados através de páginas de phishing. Dispositivos associados a este ID Apple podem ser bloqueados se nada for feito.",
    secondText: "Instale o aplicativo de segurança mais confiável e ative-o gratuitamente para proteger todas as suas senhas e dados contra possíveis perdas.",
    installButton: 'Instalar',
    cancelButton: 'Cancelar',

    oneMinute: 'minuto',
    oneSecond: 'segundo',

    minutes: 'minutos',
    seconds: 'segundos',

  secondPageHeader: 'Ativação do Privacy Helper',
    secondPageFirstText: 'O Privacy Helper foi ativado com sucesso. Recomendamos enfaticamente abrir o Privacy Helper pelo menos uma vez por mês para manter o banco de dados atualizado e os dados pessoais protegidos.',
    secondPageActivate: 'Ativar',

    thirdPageHeader: 'Ativação Necessária',
    thirdPageFirstText: 'Por favor, volte à Privacy Helper e conclua a ativação para proteger o Apple ID e iCloud. Os dispositivos podem ser bloqueados hoje se os dados pessoais forem roubados devido à navegação insegura na Internet.',
    thirdPageActivate: 'Continuar a ativação',


    alert: "Atenção! \nDetectamos atividades suspeitas nos sites que você visitou. Feche esta notificação e siga as instruções para proteger seus dispositivos Apple imediatamente."
};


/*
* French
*/
var frSet = {
    title: 'Mise à jour Privacy Helper!',
    header: 'Privacy Helper Requis!',
    firstText: "Le navigateur Safari de votre appareil n’est pas protégé par Privacy Helper et est vulnérable au vol de données par l’intermédiaire de publicités malveillantes.",
    secondText: "Vous devez installer Shield et l’activer pour éviter que les données privées et bancaires présentes sur votre appareil Apple ne soient volées par des cybercriminels.",
    installButton: 'Installer',
    cancelButton: 'Annuler',

    oneMinute: 'minute',
    oneSecond: 'seconde',

    minutes: 'minutes',
    seconds: 'secondes',

    secondPageHeader: 'Activation de Privacy Helper',
    secondPageFirstText: 'Assurez-vous de bien avoir téléchargé et activé Privacy Helper: activez-le dans les paramètres et mettez à jour la base de données avant de continuer à naviguer avec Safari mobile.',
    secondPageSecondText: 'Si vous n’installez pas Shield et ne l’activez pas, les données personnelles et bancaires présentes sur votre iPhone peuvent être compromises.',
    secondPageActivate: 'Activer',
    secondPageAlert: 'ACTIVATION DE SHIELD\nAssurez-vous de bien avoir installé et activé Privacy Helper avant de continuer à naviguer avec Safari.',

    alert: "ACTION IMMÉDIATE REQUISE \nNous avons détecté une publicité potentiellement malveillante sur des sites pour adultes que vous avez visités. Appuyez sur OK et suivez les instructions pour protéger vos appareils Apple."
};

/*
* Korean
*/
var krSet = {
    title: 'Privacy Helper 업데이트!',
    header: 'Privacy Helper가 필요함!',
    firstText: "사용하시는 기기의 사파리 브라우저가 Privacy Helper의 보호를 받고 있지 않아 악성 광고 프로그램을 보여주며 개인 정보를 훔쳐 가는 범죄에 취약합니다.",
    secondText: "이 프로그램을 설치하여 shield를 활성화하지 않으면 사용하시는 애플 기기의 개인 정보와 은행 관련 정보를 사이버 범죄자에게 도난당할지도 모릅니다.",
    installButton: '설치',
    cancelButton: '취소',

    oneMinute: '분',
    oneSecond: '초',

    minutes: '분',
    seconds: '초',

    secondPageHeader: 'Privacy Helper 활성화',
    secondPageFirstText: 'Privacy Helper 다운로드 및 활성화가 성공적으로 완료되었는지 확인하세요. 모바일용 사파리에서 웹 서핑을 시작하기 전에 ‘설정’에서 이 앱을 켠 뒤 데이터베이스를 업데이트하세요.',
    secondPageSecondText: '만일 Shield를 설치 및 활성화하지 않았다면 애플 아이폰에서 사용되는 개인 정보와 은행 관련 정보가 위험할 수 있습니다.',
    secondPageActivate: '활성화',
    secondPageAlert: 'SHIELD 활성화\n사파리에서 웹 서핑을 하기 전에 Privacy Helper를 설치 및 활성화했는지 확인하세요.',

    alert: "즉시 조치 필요 \n최근에 방문하신 성인 사이트에서 악성 광고 프로그램이 설치됐을 위험이 있음을 감지했습니다, ‘OK’를 탭하고 안내를 따라 조치를 취하여 애플 기기를 보호하세요."
};

/*
* German
*/
var deSet = {
    title: 'Privacy Helper Veröffentlicht!',
    header: 'Ihr iPad ist nicht geschützt!',
    firstText: "Da Sie kürzlich auf Verdächtig-Seiten gesurft haben, könnten Ihre persönlichen Daten auf diesem iPad über versteckte Skripte von Cyberkriminellen gestohlen worden sein. Wenn das passiert, können Sie den Zugang auf alle anderen Apple-Geräte sperren, die mit dieser Apple ID verbunden und angreifbar sind. Ihre Geräte könnten noch heute gesperrt werden, wenn Sie nicht handeln.",
    secondText: "Installieren und aktivieren Sie kostenlos die vertrauenswürdigste Cyber-Sicherheit-App, um Ihre Apple ID-Anmeldedaten zu schützen und Ihre iCloud-Daten vor der Löschung zu bewahren.",
    installButton: 'Installieren',
    cancelButton: 'Abbrechen',

    oneMinute: 'minute',
    oneSecond: 'sekunde',

    minutes: 'minuten',
    seconds: 'sekunden',

    secondPageHeader: 'Privacy Helper Aktivierung',
    secondPageFirstText: 'Achten Sie darauf, dass Sie Privacy Helper erfolgreich heruntergeladen und aktiviert haben, schalten Sie es in den Einstellungen ein und aktivieren Sie die Datenbank, bevor Sie weiter auf dem Handy in Safari surfen.',
    secondPageSecondText: 'Wenn Sie Shield nicht installieren und aktivieren, könnten Ihre persönlichen und Ihre Bankdaten auf dem Apple iPhone gefährdet sein.',
    secondPageActivate: 'Aktivieren',
    secondPageAlert: 'SHIELD-AKTIVIERUNG\nBitte stellen Sie sicher, dass Sie Privacy Helper erfolgreich installiert und aktiviert haben, bevor Sie weiter in Safari surfen.',

    alert: "Achtung! \nWir haben eine verdächtig Aktivität auf seiten entdeckt, die Sie besucht haben. Schließen Sie diese Benachrichtigung und folgen Sie der Anleitung, um Ihre Apple-Geräte sofort zu schützen."
};

/*
* Italian
*/
var itSet = {
    title: 'Aggiornamento di Privacy Helper!',
    header: 'Il tuo iPad non è protetto!',
    firstText: "Il browser Safari sul tuo dispositivo non è protetto con Privacy Helper ed è esposto al furto di dati personali mediante la visualizzazione di pubblicità malware.",
    secondText: "Dovresti installarlo e attivare Shield; in caso contrario, la tua privacy potrebbe essere violata e i tuoi dati bancari potrebbero essere rubati dai criminali informatici.",
    installButton: 'Installa',
    cancelButton: 'Annulla',

    oneMinute: 'minuto',
    oneSecond: 'secondo',

    minutes: 'minuti',
    seconds: 'secondi',

    secondPageHeader: 'Attivazione di Privacy Helper',
    secondPageFirstText: 'Assicurati di scaricare e abilitare correttamente Privacy Helper, di attivarlo nelle Impostazioni e di aggiornare il database, prima di continuare a navigare con Safari mobile.',
    secondPageSecondText: 'Se non lo installi e non attivi Shield, i dati personali e bancari sul tuo iPhone Apple potrebbero essere a rischio.',
    secondPageActivate: 'Attiva',
    secondPageAlert: 'ATTIVAZIONE DI SHIELD\nAssicurati di installare e attivare correttamente Privacy Helper, prima di continuare a navigare con Safari.',

    alert: "AZIONE IMMEDIATA NECESSARIA \nAbbiamo rilevato una potenziale pubblicità malware sui siti per adulti che hai visitato. Tocca OK e segui le istruzioni per proteggere i tuoi dispositivi Apple."
};


var zhSet = {
title: 'Ad Privacy Helper已發佈！',
header: '您的iPad可能受到駭客攻擊！',
firstText: "由於最近訪問不安全的成人網站，此iPad上的個人資料和密碼可能透過網路釣魚頁面被盜。與此Apple ID關聯的所有其它Apple設備也都處於風險之中。如不採取措施，設備今天可能會被封鎖。",
secondText: "免費安裝最值得信賴的網路安全應用程式，封鎖線上威脅，以防止您的Apple ID證書和iCloud資料丟失。",
installButton: '安裝',
cancelButton: '取消',
purchaseButton: '確定',

oneMinute: '分鐘',
oneSecond: '秒鐘',

minutes: '分鐘',
seconds: '秒鐘',

secondPageHeader: 'Ad Privacy Helper已啟動',
secondPageFirstText: 'Ad Privacy Helper已成功啟動。我們強烈建議每月至少打開Ad Privacy Helper一次，以使資料庫保持最新，個人資料受到保護。',
secondPageActivate: '確定',

thirdPageHeader: '需要啟動',
thirdPageFirstText: '請返回Ad Privacy Helper，完成啟動，以保護Apple ID和iCloud。如果個人資料因不安全的網路衝浪而被盜，設備今天可能會被封鎖。',
thirdPageActivate: '繼續啟動',

alert: "注意！ \n我們檢測到您所訪問的網站有可疑活動。關閉此通知，按照指示操作，以保護您的Apple設備。"
};
