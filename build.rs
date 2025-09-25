extern crate cc;
#[cfg(windows)]
extern crate winres;

#[cfg(windows)]
fn build_windows() {
    let file = "src/platform/windows.cc";
    let file2 = "src/platform/windows_delete_test_cert.cc";

    cc::Build::new()
        .file(file)
        .file(file2)
        .compile("windows");

    println!("cargo:rustc-link-lib=WtsApi32");
    println!("cargo:rerun-if-changed={}", file);
    println!("cargo:rerun-if-changed={}", file2);

    // Branding e ícone StormDesk
    let mut res = winres::WindowsResource::new();
    res.set_icon("res/icon.ico");
    res.set("ProductName", "StormDesk");
    res.set("FileDescription", "StormDesk Remote Desktop");
    res.set("CompanyName", "StormDesk Ltd.");
    res.set("OriginalFilename", "StormDesk.exe");
    res.compile().unwrap();
}

#[cfg(target_os = "macos")]
fn build_mac() {
    let file = "src/platform/macos.mm";
    let mut b = cc::Build::new();

    if let Ok(os_version::OsVersion::MacOS(v)) = os_version::detect() {
        let v = v.version;
        if v.contains("10.14") {
            b.flag("-DNO_InputMonitoringAuthStatus=1");
        }
    }

    b.file(file).compile("macos");

    println!("cargo:rerun-if-changed={}", file);
    println!("cargo:rustc-link-lib=framework=ApplicationServices");
}

fn install_android_deps() {
    let target_os = std::env::var("CARGO_CFG_TARGET_OS").unwrap();
    if target_os != "android" {
        return;
    }

    let mut target_arch = std::env::var("CARGO_CFG_TARGET_ARCH").unwrap();
    target_arch = match target_arch.as_str() {
        "x86_64" => "x64".to_string(),
        "x86" => "x86".to_string(),
        "aarch64" => "arm64".to_string(),
        _ => "arm".to_string(),
    };

    let target = format!("{}-android", target_arch);
    let mut path: std::path::PathBuf = std::env::var("VCPKG_ROOT").unwrap().into();

    if let Ok(vcpkg_root) = std::env::var("VCPKG_INSTALLED_ROOT") {
        path = vcpkg_root.into();
    } else {
        path.push("installed");
    }

    path.push(target);

    println!("cargo:rustc-link-search={}", path.join("lib").to_str().unwrap());
    println!("cargo:rustc-link-lib=ndk_compat");
    println!("cargo:rustc-link-lib=oboe");
    println!("cargo:rustc-link-lib=c++");
    println!("cargo:rustc-link-lib=OpenSLES");
}

fn main() {
    // Gera versão a partir do hbb_common
    hbb_common::gen_version();

    // Android
    install_android_deps();

    // Windows
    #[cfg(windows)]
    build_windows();

    // macOS
    #[cfg(target_os = "macos")]
    build_mac();

    // Sempre recompilar se build.rs mudar
    println!("cargo:rerun-if-changed=build.rs");
}
