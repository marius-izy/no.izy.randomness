import ClaySDK
//...
//'self' must conform to ClayDelegate, the apiKey will be provided to you
let clay = ClaySDK(installationUID: "SOME_UNIQUE_ID", apiKey: "THE_API_PUBLIC_KEY", delegate: self)
//...
// Public key that you need to send via API to activate mobile key
let publicKey = clay.getPublicKey()
//...
//'yourOpenDoorDelegate' must conform to OpenDoorDelegate
clay.openDoor(with: "your-encrypted-key", delegate: yourOpenDoorDelegate)
