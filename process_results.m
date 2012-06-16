t = load('thrust.dat');
v = load('vexcl.dat');
n = unique(t(:,1))';

tavg = [];
vavg = [];

for i = n
    I = find(t(:,1) == i);

    time = sum(t(I,2)) / length(I);
    tavg = [tavg time];

    time = sum(v(I,2)) / length(I);
    vavg = [vavg time];
end

figure(1)
set(gca, 'FontSize', 18)

plot(n, tavg, 'ko-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

hold on

plot(n, vavg, 'ro-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

xlabel('N');
ylabel('T (sec)');

legend('thrust', 'vexcl', 'location', 'northwest');
legend boxoff

print('-depsc', 'abs.eps');

figure(2)
set(gca, 'FontSize', 18)

plot(n, vavg ./ tavg, 'ko-', ...
		'linewidth', 2, 'markersize', 6, 'markerfacecolor', 'w');

xlabel('N');
ylabel('T(vexcl) / T(thrust)');

print('-depsc', 'rel.eps');
