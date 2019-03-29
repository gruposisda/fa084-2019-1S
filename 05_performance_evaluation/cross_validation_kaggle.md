*This tutorial is part of the [Learn Machine Learning](https://www.kaggle.com/learn/learn-machine-learning/) series. In this step, you will learn how to use cross-validation for better measures of model performance.*


# What is Cross Validation

Machine learning is an iterative process.

You will face choices about predictive variables to use, what types of models to use,what arguments to supply those models, etc. We make these choices in a data-driven way by measuring model quality of various alternatives.

You've already learned to use `train_test_split` to split the data, so you can measure model quality on the test data.  Cross-validation extends this approach to model scoring (or "model validation.") Compared to `train_test_split`, cross-validation gives you a more reliable measure of your model's quality, though it takes longer to run.

## The Shortcoming of Train-Test Split

Imagine you have a dataset with 5000 rows.  The `train_test_split` function has an argument for `test_size` that you can use to decide how many rows go to the training set and how many go to the test set.  The larger the test set, the more reliable your measures of model quality will be.  At an extreme, you could imagine having only 1 row of data in the test set.  If you compare alternative models, which one makes the best predictions on a single data point will be mostly a matter of luck.

You will typically keep about 20% as a test dataset.  But even with 1000 rows in the test set, there's some random chance in determining model scores.  A model might do well on one set of 1000 rows, even if it would be inaccurate on a different 1000 rows.  The larger the test set, the less randomness (aka "noise") there is in our measure of model quality.

But we can only get a large test set by removing data from our training data, and smaller training datasets mean worse models.  In fact, the ideal modeling decisions on a small dataset typically aren't the best modeling decisions on large datasets.

## The Cross-Validation Procedure

In cross-validation, we run our modeling process on different subsets of the data to get multiple measures of model quality. For example, we could have 5 **folds** or experiments.  We divide the data into 5 pieces, each being 20% of the full dataset.

![cross-validation-graphic](https://i.stack.imgur.com/1fXzJ.png)


We run an experiment called experiment 1 which uses the first fold as a holdout set, and everything else as training data. This gives us a measure of model quality based on a 20% holdout set, much as we got from using the simple train-test split.
We then run a second experiment, where we hold out data from the second fold (using everything except the 2nd fold for training the model.) This gives us a second estimate of model quality.
We repeat this process, using every fold once as the holdout.  Putting this together, 100% of the data is used as a holdout at some point.

Returning to our example above from train-test split, if we have 5000 rows of data, we end up with a measure of model quality based on 5000 rows of holdout (even if we don't use all 5000 rows simultaneously.

## Trade-offs Between Cross-Validation and Train-Test Split
Cross-validation gives a more accurate measure of model quality, which is especially important if you are making a lot of modeling decisions.  However, it can take more time to run, because it estimates models once for each fold.  So it is doing more total work.

Given these tradeoffs, when should you use each approach?
On small datasets, the extra computational burden of running cross-validation isn't a big deal.  These are also the problems where model quality scores would be least reliable with train-test split.  So, if your dataset is smaller, you should run cross-validation.

For the same reasons, a simple train-test split is sufficient for larger datasets.  It will run faster, and you may have enough data that there's little need to re-use some of it for holdout.

There's no simple threshold for what constitutes a large vs small dataset.  If your model takes a couple minute or less to run, it's probably worth switching to cross-validation.  If your model takes much longer to run, cross-validation may slow down your workflow more than it's worth.

Alternatively, you can run cross-validation and see if the scores for each experiment seem close. If each experiment gives the same results, train-test split is probably sufficient.
