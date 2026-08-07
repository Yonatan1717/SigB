% Oppgave 1
% Oppgave 1

% a)
lv_a = 2:2:20;
% fprintf("lv_a: %s\n\n", mat2str(lv_a));

% b)
lv_b = power(1:10, 3);
% fprintf("lv_b: %s\n\n", mat2str(lv_b));

% c)
kv_c = power((1:10), 2)'; 
% fprintf("kv_c: %s\n\n", mat2str(kv_c));

% d)
lv_d = kv_c(2:2:end)';
% fprintf("lv_d: %s\n\n", mat2str(lv_d));


