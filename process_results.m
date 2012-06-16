close all
clear all

t  = load('thrust.dat');
v1 = load('vexcl_1gpu.dat');
v2 = load('vexcl_2gpu.dat');
v3 = load('vexcl_3gpu.dat');
n = unique(t(:,1))';

vc = load('vexcl_cpu.dat');
m = unique(vc(:,1))';

tavg  = [];
v1avg = [];
v2avg = [];
v3avg = [];

for i = n
    I = find(t(:,1) == i);

    time = sum(t(I,2)) / length(I);
    tavg = [tavg time];

    time = sum(v1(I,2)) / length(I);
    v1avg = [v1avg time];

    time = sum(v2(I,2)) / length(I);
    v2avg = [v2avg time];

    time = sum(v3(I,2)) / length(I);
    v3avg = [v3avg time];
end

vcavg = [];

for i = m
    I = find(vc(:,1) == i);

    time = sum(vc(I,2)) / length(I);
    vcavg = [vcavg time];
end

figure(1)
set(gca, 'FontSize', 18)

loglog(n, tavg, 'ko-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

hold on

loglog(n, v1avg, 'ro-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

loglog(n, v2avg, 'bo-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

loglog(n, v3avg, 'go-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

loglog(m, vcavg, 'md-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

xlabel('N');
ylabel('T (sec)');

legend('thrust', 'vexcl 1gpu', 'vexcl 2gpu', 'vexcl 3gpu', 'vexcl cpu', 'location', 'northwest');
legend boxoff

print('-depsc', 'abs.eps');

figure(2)
set(gca, 'FontSize', 18)

loglog(n, v1avg ./ tavg, 'ro-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

hold on

loglog(n, v2avg ./ tavg, 'bo-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

loglog(n, v3avg ./ tavg, 'go-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

loglog(n, ones(size(n)), 'k:');

legend('1gpu', '2gpu', '3gpu');
legend boxoff

xlabel('N');
ylabel('T(vexcl) / T(thrust)');

print('-depsc', 'rel.eps');
