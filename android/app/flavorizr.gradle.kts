import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("production") {
            dimension = "flavor-type"
            applicationId = "com.np.app.production"
            resValue(type = "string", name = "app_name", value = "Production App")
        }
        create("staging") {
            dimension = "flavor-type"
            applicationId = "com.np.app.staging"
            resValue(type = "string", name = "app_name", value = "Staging App")
        }
    }
}