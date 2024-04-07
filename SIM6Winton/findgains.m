Ki = diag([0,0,0]);
Kp = diag((0.11277)^2*[3,4,2])*2.1;
Kd = diag(2*.59115*(0.11277)*[3,4,2])*1.5;



KpTrack = Kp;
KdTrack = Kd;

out = sim('SIM6reva');
settle = isSettled(out.EulerAngles.Data);
os = isOS(out.EulerAngles.Data);
input("press enter")
close all
it = 2;
factor = 1.1;

while ~all(all([settle; os]))
    for i = 1:3
        if ~os(i)
            Kd(i,i) = Kd(i,i)*factor;
        end
        if ~settle(i)
            Kd(i,i) = Kd(i,i)*sqrt(factor);
            Kp(i,i) = Kp(i,i)*sqrt(factor);
        end
    end
    
    KpTrack(:,:,it) = Kp;
    KdTrack(:,:,it) = Kd;

    it = it + 1;

    assignin('base', 'Kd', Kd);
    assignin('base', 'Kp', Kp);

    out = sim('SIM6reva');
    settle = isSettled(out.EulerAngles.Data)
    os = isOS(out.EulerAngles.Data)
    % input("press enter")
    close all
end

    



function output = isSettled(angles)
    initVal = abs(angles(1,:));
    tfVal = abs(angles(60,:));

    output = tfVal < (initVal * .02);
end

function output = isOS(angles)
    initVal = abs(angles(1,:));
    pks1 = findpeaks(abs(angles(:,1)));
    pks2 = findpeaks(abs(angles(:,2)));
    pks3 = findpeaks(abs(angles(:,3)));
    pks = [pks1(1), pks2(1), pks3(1)];
    
    output = pks./abs(initVal) < .1;
end