t  = load('thrust.dat');
v1 = load('vexcl_1gpu.dat');
v2 = load('vexcl_2gpu.dat');
v3 = load('vexcl_3gpu.dat');
n = unique(t(:,1))';

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

figure(1)
set(gca, 'FontSize', 18)

plot(n, tavg, 'ko-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

hold on

plot(n, v1avg, 'ro-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

plot(n, v2avg, 'ro-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

plot(n, v3avg, 'ro-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

xlabel('N');
ylabel('T (sec)');

legend('thrust', 'vexcl 1gpu', 'vexcl 2gpu', 'vexcl 3gpu', 'location', 'northwest');
legend boxoff

print('-depsc', 'abs.eps');

figure(2)
set(gca, 'FontSize', 18)

plot(n, v1avg ./ tavg, 'ko-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

hold on

plot(n, v2avg ./ tavg, 'ko-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

plot(n, v3avg ./ tavg, 'ko-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

legend('1gpu', '2gpu', '3gpu');

xlabel('N');
ylabel('T(vexcl) / T(thrust)');

print('-depsc', 'rel.eps');
