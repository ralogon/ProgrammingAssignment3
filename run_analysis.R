# Set working directory where data is avaulable
setwd('D:/Dropbox/Cursos/Coursera Data Science Specialization/Course 3 - Getting and cleaning data/Week4/dataCourseProject/UCI HAR Dataset')

# Read training data and labels
X_train <- read.csv('train/X_train.txt', header = FALSE, sep = '')
Y_train <- read.csv('train/Y_train.txt', header = FALSE, sep = '')
# nrow(X_train)
# ncol(X_train)
# nrow(Y_train)
# ncol(Y_train)

# Read test data and labels
X_test <- read.csv('test/X_test.txt', header = FALSE, sep = '')
Y_test <- read.csv('test/Y_test.txt', header = FALSE, sep = '')
# nrow(X_test)
# ncol(X_test)
# nrow(Y_test)
# ncol(Y_test)

# Join test and training
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
# nrow(X)
# nrow(Y)

# Load feature names
feature_names <- read.csv('features.txt', header = FALSE, sep = '')[2]
# head(feature_names)
# nrow(feature_names)

# Assign measure names to dataset
names(X) <- feature_names$V2
# names(X)

# Get just features with mean() and std()
names_mean <- grep('mean\\(\\)', names(X))
names_std <- grep('std\\(\\)', names(X))
names_mean_std <- names(X)[c(names_mean, names_std)]
# print(names_mean_std)
X_mean_std <- X[names_mean_std]
print(names(X_mean_std))

# Create descriptive names for activities (labels)
Y[Y$V1 == 1,] = 'WALKING'
Y[Y$V1 == 2,] = 'WALKING_UPSTAIRS'
Y[Y$V1 == 3,] = 'WALKING_DOWNSTAIRS'
Y[Y$V1 == 4,] = 'SITTING'
Y[Y$V1 == 5,] = 'STANDING'
Y[Y$V1 == 6,] = 'LAYING'
names(Y) = 'ActivityNames'
# head(Y)
# unique(Y)

# Label the data set with descripting activity set
X_labeled <- cbind(X_mean_std, Y)
ncol(X_labeled)

# Load subject data
subject_train <- read.csv('train/subject_train.txt', header = FALSE, sep = '')
subject_test <- read.csv('test/subject_test.txt', header = FALSE, sep = '')
# nrow(subject_train)
# nrow(subject_test)
subject <- rbind(subject_train, subject_test)
names(subject) <- 'Subject'
# head(subject)

# Merge subject with dataset
X_labeled_subject <- cbind(X_labeled, subject)
# ncol(X_labeled_subject)
# names(X_labeled_subject)

# Obtain mean of all variables for each activity and user
final_dataset <- X_labeled_subject %>% 
                 group_by(ActivityNames, Subject) %>% 
                 summarise_all(funs(mean))
          
write.table(final_dataset, 
            '../../Assignment Submission/week4AssignmentDataset.txt', 
            row.names = FALSE)
