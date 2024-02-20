# CPP_MODULES_INIT

Are you tired to write classes in *Orthodox Canonical Form* at 42? You came to the right place.

CPP_INIT is a script i created to automaticly generate classes for the CPP_Modules of 42 School, the script creates the exercise folder and the classes, if they don't exist. The .hpp files are created inside the includes folder and the .cpp files inside the sources folder. The classes are autocmaticly created in *Orthodox Canonical Form* because it's mandatory for the 42 CPP_Modules Projects. Enjoy saving 10 mins every exercise.

## Installation

Clone this Repo.
```bash
git clone git@github.com:Chaleira/cpp_init.git
```

Go inside the repo.
```bash
cd cpp_init #or whatever name you gave when clonnig
```

Give the script executable permissions.
```bash
chmod +x cpp_init.sh
```

Run
```bash
./cpp_init.sh -config
```
Now close that terminal and we are all Done.

## Usage
You can use the command ``cpp_init`` wherever you want to generate classes
The first argument is the folder where you want to create the classes (if the folder doesn't exist the program will create it)
From the second argument on you will write the name of the classes you want to create
```bash
cpp_init #Exercise_Folder #nameOfClass1 #nameOfClass2 #nameOfClass3 [...]
```
You can run this command for help
```bash
cpp_init -h
```
if the folder or the classes already exist the files won't be created again or modified, only the class that don't yet exist will be created.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.
