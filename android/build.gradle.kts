subprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    val configureNamespace = {
        if (project.plugins.hasPlugin("com.android.library")) {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val getNamespace = android.javaClass.getMethod("getNamespace")
                    val currentNamespace = getNamespace.invoke(android)
                    if (currentNamespace == null) {
                        val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                        val packageId = "dev.isar.${project.name.replace("-", "_").replace(".", "_")}"
                        setNamespace.invoke(android, packageId)
                        println("Dynamically set namespace for ${project.name} to $packageId")
                    }
                } catch (e: Exception) {
                    println("Failed to set namespace for ${project.name}: ${e.message}")
                }
            }
        }
    }
    if (project.state.executed) {
        configureNamespace()
    } else {
        project.afterEvaluate {
            configureNamespace()
        }
    }
}


