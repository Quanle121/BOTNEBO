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
