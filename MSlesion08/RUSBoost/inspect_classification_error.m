function inspect_classification_error(X_test, L_test, model)
tic
figure('Visible','off');
plot(loss(model,X_test,L_test,'mode','cumulative'));
fprintf('Time spent on plotting in mins: %f\n', toc/60);
grid on;
xlabel('Number of trees');
ylabel('Test classification error');
print('Cumulative_Classification_Error','-dpng');
