<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>FOUL</title>
<style>body{background:#0a0a0a;color:#fff;font-family:Arial;display:flex;justify-content:center;align-items:center;min-height:100vh;margin:0}.box{background:#151515;padding:30px;border-radius:15px;border:1px solid red;width:340px}h2{color:red;text-align:center;letter-spacing:4px;margin:0 0 25px}input{width:100%;padding:13px;margin:8px 0;background:#000;border:1px solid #333;color:#fff;border-radius:8px}button{width:100%;padding:13px;background:red;border:none;color:#fff;font-weight:bold;border-radius:8px;margin-top:15px} #thongbao{text-align:center;margin-top:12px;font-weight:bold}.ok{color:#00ff66}.sai{color:#ff4444}#panel{display:none}.item{display:flex;justify-content:space-between;padding:18px 0;border-bottom:1px solid #222}.dot{width:20px;height:20px;border-radius:50%;background:#fff;cursor:pointer}.dot.active{background:red}</style>
</head>
<body>
<div id="loginBox" class="box"><h2>FOUL</h2><input id="tk" placeholder="Tài khoản"><input id="mk" type="password" placeholder="Mật khẩu"><button onclick="login()">ĐĂNG NHẬP</button><div id="thongbao"></div></div>
<div id="panel" class="box"><h2>FOUL</h2><div class="item"><span>AIMLOCK V2</span><div class="dot" onclick="this.classList.toggle('active')"></div></div><div class="item"><span>MAGIC BULLET</span><div class="dot" onclick="this.classList.toggle('active')"></div></div><div class="item"><span>AIM 100%</span><div class="dot" onclick="this.classList.toggle('active')"></div></div><div class="item"><span>CHAMS V3</span><div class="dot" onclick="this.classList.toggle('active')"></div></div></div>
<script>
function getDeviceId(){let id=localStorage.getItem('foul_device_id');if(!id){id='DEV-'+Math.random().toString(36).substring(2,8)+Date.now().toString(36);localStorage.setItem('foul_device_id',id);}return id;}
function login(){
 let tk=document.getElementById('tk').value.trim();let mk=document.getElementById('mk').value.trim();let tb=document.getElementById('thongbao');let data=JSON.parse(localStorage.getItem('foul_acc')||"[]");let deviceId=getDeviceId();
 if(tk==="TNX08-VIP-0xXH8YnMbPQA" && mk==="TNX-0xM9CWbktyuW"){tb.className="ok";tb.innerHTML="ADMIN OK";setTimeout(()=>{loginBox.style.display='none';panel.style.display='block'},500);return;}
 let idx=data.findIndex(a=>a.tk===tk&&a.mk===mk);if(idx==-1){tb.className="sai";tb.innerHTML="Sai TK/MK";return;}
 let acc=data[idx];
 if(acc.expiry < 9000000000000 && Date.now() > acc.expiry){data.splice(idx,1);localStorage.setItem('foul_acc',JSON.stringify(data));tb.className="sai";tb.innerHTML="Tài khoản đã hết hạn và bị thu hồi!";return;}
 if(!acc.devices) acc.devices=[];if(!acc.devices.includes(deviceId)){if(acc.devices.length>=2){tb.className="sai";tb.innerHTML="TK đủ 2 thiết bị rồi!";return;}acc.devices.push(deviceId);data[idx]=acc;localStorage.setItem('foul_acc',JSON.stringify(data));}
 let con=acc.expiry==9999999999999?"VĨNH VIỄN":Math.ceil((acc.expiry-Date.now())/86400000)+" ngày";
 tb.className="ok";tb.innerHTML=`OK - HSD: ${con} - TB ${acc.devices.length}/2`;setTimeout(()=>{loginBox.style.display='none';panel.style.display='block'},600);
}
</script>
</body>
</html>
MzlVel = 0;
MyBullet = objNull;
MyTgt = objNull;
PrevTgt = objNull;
HitFlag = false;
Lines = [];
MyCam = "camera" camCreate getPos player;
ViewMode = "";
CamFlag = false;		// switch as you like. true - use the bullet camera, false - don't use the bullet camera.
SlowmoFlag = true;		// switch as you like. true - use the slowmotion, false - don't use the bullet slowmotion.

player addEventHandler ["Fired",{
	if (HitFlag) exitWith {};

	if (SlowmoFlag or CamFlag) then {setAccTime 0.01;};
	Lines = [];
	private _bullet = _this # 6;
	MzlVel = vectorMagnitude velocity _bullet;
	MyBullet = _bullet;

	_bullet addEventHandler ["HitPart",{
		params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius" ,"_surfaceType"];

		private _tgtList = (_hitEntity nearEntities ["Man",15]) - [_hitEntity,PrevTgt,player];
		if (_tgtList isEqualTo []) exitWith {
			if (SlowmoFlag or CamFlag) then {setAccTime 1;};
			player switchCamera ViewMode;
			deleteVehicle _projectile;
			HitFlag = false;
			MyTgt = objNull;
		};

		private _tgt = _tgtList # 0; MyTgt = _tgt;
		private _tgtPos = AGLToASL unitAimPositionVisual _tgt;
		private _newVct = _pos vectorFromTo _tgtPos;
		private _newPos = _pos vectorAdd (vectorNormalized _newVct);
		_projectile setVectorDirAndUp [_newVct,[0,0,1]];
		_projectile setPosWorld _newPos;
		private _newVel = _newVct vectorMultiply MzlVel;
		_projectile setVelocity _newVel;
		PrevTgt = _hitEntity;
		HitFlag = true;
		Lines pushBack [ASLToAGL _pos, ASLToAGL _tgtPos];
	}];

	if (CamFlag) then {
		MyCam attachTo [_bullet,[0,0,0]];
		ViewMode = cameraView;
		switchCamera MyCam;
	};

	_bullet addEventHandler ["deleted",{
		if (SlowmoFlag or CamFlag) then {setAccTime 1;};
		player switchCamera ViewMode;
		HitFlag = false;
		MyTgt = objNull;
	}];
}];

// Adjust Ballistics
addMissionEventHandler ["EachFrame",{
	if (not HitFlag) exitWith {};
	Private _tgt = MyTgt; if (isNull _tgt) exitWith {};
	private _bullet = MyBullet; if (isNull _bullet) exitWith {};

	private _newVct = getPosVisual _bullet vectorFromTo unitAimPositionVisual _tgt;
	// compare current velocity vector to expected vector with vectorCos
	private _vctCos = velocity _bullet vectorCos _newVct;
	if (_vctCos < 0.01 and _vctCos > -0.01) exitWith {};

	private _newVel = _newVct vectorMultiply MzlVel;
	_bullet setVectorDirAndUp [_newVel,[0,0,1]];
	_bullet setVelocity _newVel;
}];

addMissionEventHandler ["Draw3D",{
	private _lines = + Lines;
	private _elm = [];
	for "_i" from 0 to (count _lines - 1) do {
		_elm = _lines # _i;
		drawLine3D [_elm # 0, _elm # 1, [1,0,0,1]];
	};

	if (not HitFlag) exitWith {};
	private _bullet = MyBullet; if (isNull _bullet) exitWith {};
	drawIcon3D ["\A3\ui_f\data\igui\cfg\targeting\LaserTarget_ca.paa", [1,0,0,1], getPos _bullet, 5, 5, 0];
}];
