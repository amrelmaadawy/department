allprojects {
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
    afterEvaluate {
        val androidExtension = extensions.findByName("android")
        if (androidExtension != null) {
            try {
                val getNamespaceMethod = androidExtension.javaClass.getMethod("getNamespace")
                val ns = getNamespaceMethod.invoke(androidExtension) as? String
                if (ns == null || ns.isEmpty()) {
                    var pkg = group.toString()
                    if (pkg.isEmpty() || pkg == "unspecified") {
                        val manifestFile = file("src/main/AndroidManifest.xml")
                        if (manifestFile.exists()) {
                            val regex = """package\s*=\s*["']([^"']+)["']""".toRegex()
                            val match = regex.find(manifestFile.readText())
                            if (match != null) {
                                pkg = match.groupValues[1]
                            }
                        }
                    }
                    if (pkg.isEmpty() || pkg == "unspecified") {
                        pkg = "com.library." + project.name.replace("-", "_")
                    }
                    val setNamespaceMethod = androidExtension.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespaceMethod.invoke(androidExtension, pkg)
                }
            } catch (e: Exception) {
                // Ignore if reflection fails
            }

            try {
                val getCompileOptions = androidExtension.javaClass.getMethod("getCompileOptions")
                val compileOptions = getCompileOptions.invoke(androidExtension)
                if (compileOptions != null) {
                    val setSource = compileOptions.javaClass.getMethod("setSourceCompatibility", org.gradle.api.JavaVersion::class.java)
                    val setTarget = compileOptions.javaClass.getMethod("setTargetCompatibility", org.gradle.api.JavaVersion::class.java)
                    setSource.invoke(compileOptions, org.gradle.api.JavaVersion.VERSION_17)
                    setTarget.invoke(compileOptions, org.gradle.api.JavaVersion.VERSION_17)
                }
            } catch (e: Exception) { }

            try {
                val compileSdkMethod = androidExtension.javaClass.getMethod("compileSdkVersion", Int::class.java)
                compileSdkMethod.invoke(androidExtension, 36)
            } catch (e: Exception) {
                try {
                    val setCompileSdk = androidExtension.javaClass.getMethod("setCompileSdkVersion", Int::class.java)
                    setCompileSdk.invoke(androidExtension, 36)
                } catch (e2: Exception) { }
            }
        }

        tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile::class.java).configureEach {
            compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
        tasks.withType(JavaCompile::class.java).configureEach {
            sourceCompatibility = "17"
            targetCompatibility = "17"
        }
    }
}

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
