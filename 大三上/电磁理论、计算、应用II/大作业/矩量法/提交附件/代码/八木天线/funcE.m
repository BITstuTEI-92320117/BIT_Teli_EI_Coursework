function E = funcE(r, z, I, a, dl_all, k, Z0, N, num, M, d)
%% 计算辐射电场
% 远场空间离散
theta = 0: pi/M: pi;
phi = 0: pi/M: 2*pi;
L = length(theta);
W = length(phi);

% 累加计算总场
E = zeros(L, W);
for i = 1:num
    r_fix = r - d(i)* sin(theta)'* sin(phi); % 每一根天线各点相对原点的半径
    % 计算每根天线在不同场点处产生的电场
    S = zeros(1, L);
    z0 = z(i,:);
    I0 = I(i,:);
    dl0 = dl_all(i);
    for m = 1:N
        rs = sqrt( z0(m)^2 + a^2 )* sign(z0(m));
        S = S + I0(m)*exp( 1j*k*rs*cos(theta) ) * dl0;
    end
    E_single = 1j*k*Z0*exp(-1j*k*r_fix).*sin(theta)'.* S' ./ (4*pi*r_fix);
    E = E + E_single;
end
E(1,:)=0;
end