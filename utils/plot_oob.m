figure('Visible','off');
plot(oobError(model));
xlabel 'Number of Grown Trees';
ylabel 'Out-of-Bag Mean Squared Error';
print('OutofBagError_D100_RF_1_1','-dpng');
