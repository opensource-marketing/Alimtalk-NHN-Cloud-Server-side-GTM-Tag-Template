___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "NHN Cloud - 카카오톡 알림톡 전송",
  "brand": {
    "id": "opensourcemarketing",
    "displayName": "오픈소스마케팅"
  },
  "description": "NHN Cloud(Toast)의 카카오톡 알림톡 발송을 할 수 있는 태그 템플릿입니다.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "appKey",
    "displayName": "Appkey",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "secretKey",
    "displayName": "SecretKey",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "senderKey",
    "displayName": "발신 키",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "templateCode",
    "displayName": "템플릿 코드",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "recipientNo",
    "displayName": "수신 번호",
    "simpleValueType": true
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "tempParams",
    "displayName": "템플릿 변수",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "변수 키",
        "name": "key",
        "type": "TEXT"
      },
      {
        "defaultValue": "",
        "displayName": "변수 값",
        "name": "value",
        "type": "TEXT"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const JSON = require('JSON');
const sendHttpRequest = require('sendHttpRequest');

const appKey = data.appKey;
const secretKey = data.secretKey;

const mergeParams = (params) => {
  let obj = {};
  for(let i = 0; i < params.length; i++) {
      let k = params[i].key;
      let v = params[i].value;
      obj[k] = v;
  }
  return obj;
};

const http_endpoint = "https://api-alimtalk.cloud.toast.com/alimtalk/v2.2/appkeys/" + appKey + "/messages";
var payload;

if (data.tempParams) {
  const tempParams = mergeParams(data.tempParams);
  var payload = {
    senderKey: data.senderKey,
    templateCode: data.templateCode,
    recipientList: [
      {
        recipientNo: data.recipientNo,
        templateParameter: tempParams,
      },
    ],
  };
} else {
  var payload = {
    senderKey: data.senderKey,
    templateCode: data.templateCode,
    recipientList: [
      {
        recipientNo: data.recipientNo
      },
    ],
  };
}

sendHttpRequest(http_endpoint, (statusCode, headers, body) => {
  if (statusCode >= 400) {
    data.gtmOnFailure();
  } else {
    data.gtmOnSuccess();
  }
}, {
  headers: {
    "Content-Type": "application/json;charset=UTF-8",
    "X-Secret-Key": secretKey
  },
  method: "POST",
  timeout: 3000
},
  JSON.stringify(payload)
);


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 2023. 1. 22. 오후 4:36:55
