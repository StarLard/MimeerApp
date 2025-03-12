//
//  SFSymbol.swift
//  MimeerKit
//
//  Created by Caleb Friden on 8/14/23.
//

import Foundation
import SwiftUI

public struct SFSymbol: Codable, Identifiable, Hashable, Sendable {
    public var category: Category
    public var systemName: String

    public var id: String { systemName }
    public var image: Image { Image(systemName: systemName) }

    public static var all: [SFSymbol] {
        SFSymbol.Category.allCases
            .map(\.symbols)
            .reduce(into: [], +=)
    }
}

// MARK: - Category

extension SFSymbol {
    public enum Category: String, Codable, CaseIterable, Identifiable, Sendable {
        public var id: String { rawValue }

        case communication
        case weather
        case objects
        case devices
        case camera
        case gaming
        case connectivity
        case transportation
        case privacy
        case people
        case home
        case fitness
        case nature
        case media
        case commerce
        case time
        case health
        case shapes
        case arrows
        case indices
        case math

        public var displayOrder: Int {
            switch self {
            case .communication:
                0
            case .weather:
                1
            case .objects:
                2
            case .devices:
                3
            case .camera:
                4
            case .gaming:
                5
            case .connectivity:
                6
            case .transportation:
                7
            case .privacy:
                8
            case .people:
                9
            case .home:
                10
            case .fitness:
                11
            case .nature:
                12
            case .media:
                13
            case .commerce:
                14
            case .time:
                15
            case .health:
                16
            case .shapes:
                17
            case .arrows:
                18
            case .indices:
                19
            case .math:
                20
            }
        }

        public var localizedTitle: String {
            switch self {
            case .communication:
                return String(localized: "Communication")
            case .weather:
                return String(localized: "Weather")
            case .objects:
                return String(localized: "Objects & Tools")
            case .devices:
                return String(localized: "Devices")
            case .camera:
                return String(localized: "Camera & Photos")
            case .gaming:
                return String(localized: "Gaming")
            case .connectivity:
                return String(localized: "Connectivity")
            case .transportation:
                return String(localized: "Transportation")
            case .privacy:
                return String(localized: "Privacy & Security")
            case .people:
                return String(localized: "People")
            case .home:
                return String(localized: "Home")
            case .fitness:
                return String(localized: "Fitness")
            case .nature:
                return String(localized: "Nature")
            case .media:
                return String(localized: "Media")
            case .commerce:
                return String(localized: "Commerce")
            case .time:
                return String(localized: "Time")
            case .health:
                return String(localized: "Health")
            case .shapes:
                return String(localized: "Shapes")
            case .arrows:
                return String(localized: "Arrows")
            case .indices:
                return String(localized: "Indices")
            case .math:
                return String(localized: "Math")
            }
        }

        public var symbols: [SFSymbol] {
            switch self {
            case .communication:
                return [
                    .micFill,
                    .arrowUpMessage,
                    .bubbleLeftFill,
                    .quoteOpening,
                    .phoneFill,
                    .envelopeFill,
                    .envelopeOpenFill,
                    .waveform,
                    .recordingtape,
                ]
            case .weather:
                return [
                    .sunMinFill,
                    .sunMaxFill,
                    .sunriseFill,
                    .sunsetFill,
                    .sunAndHorizonFill,
                    .sunDustFill,
                    .sunHazeFill,
                    .moonFill,
                    .sparkles,
                    .moonStarsFill,
                    .cloudFill,
                    .cloudDrizzleFill,
                    .cloudRainFill,
                    .cloudHeavyrainFill,
                    .cloudFogFill,
                    .cloudHailFill,
                    .cloudSnowFill,
                    .cloudSleetFill,
                    .cloudBoltFill,
                    .cloudBoltRainFill,
                    .cloudSunFill,
                    .cloudSunRainFill,
                    .cloudSunBoltFill,
                    .cloudMoonFill,
                    .cloudMoonRainFill,
                    .cloudMoonBoltFill,
                    .smokeFill,
                    .wind,
                    .windSnow,
                    .snowflake,
                    .tornado,
                    .tropicalstorm,
                    .hurricane,
                    .thermometerSunFill,
                    .thermometerSnowflake,
                    .thermometer,
                    .humidityFill,
                ]
            case .objects:
                return [
                    .cameraFill,
                    .photoFill,
                    .eraserFill,
                    .trashFill,
                    .folderFill,
                    .trayFullFill,
                    .externaldriveConnectedToLineBelowFill,
                    .archiveboxFill,
                    .docFill,
                    .note,
                    .calendar,
                    .bookFill,
                    .booksVerticalFill,
                    .bookClosedFill,
                    .textBookClosedFill,
                    .menucardFill,
                    .greetingcardFill,
                    .magazineFill,
                    .newspaperFill,
                    .bookmarkFill,
                    .rosette,
                    .graduationcapFill,
                    .ticketFill,
                    .paperclip,
                    .link,
                    .umbrellaFill,
                    .megaphoneFill,
                    .speakerFill,
                    .musicMic,
                    .magnifyingglass,
                    .flagFill,
                    .bellFill,
                    .tagFill,
                    .eyeglasses,
                    .facemaskFill,
                    .flashlightOnFill,
                    .cameraFill,
                    .gear,
                    .gearshapeFill,
                    .scissors,
                    .walletPassFill,
                    .gyroscope,
                    .gaugeLow,
                    .speedometer,
                    .barometer,
                    .metronomeFill,
                    .amplifier,
                    .diceFill,
                    .pianokeysInverse,
                    .tuningfork,
                    .paintbrushFill,
                    .bandageFill,
                    .ruler,
                    .rulerFill,
                    .levelFill,
                    .wrenchFill,
                    .hammerFill,
                    .screwdriverFill,
                    .wrenchAndScrewdriverFill,
                    .scannerFill,
                    .faxmachineFill,
                    .briefcaseFill,
                    .caseFill,
                    .latch2CaseFill,
                    .suitcaseFill,
                    .suitcaseCartFill,
                    .theatermasksFill,
                    .puzzlepieceExtensionFill,
                    .puzzlepieceFill,
                    .buildingFill,
                    .building2Fill,
                    .lockFill,
                    .lockShieldFill,
                    .lockOpenFill,
                    .keyFill,
                    .pinFill,
                    .mapFill,
                    .cpuFill,
                    .memorychipFill,
                    .headphones,
                    .radioFill,
                    .guitarsFill,
                    .fuelpumpFill,
                    .bedDoubleFill,
                    .crossVialFill,
                    .tshirtFill,
                    .filmFill,
                    .crownFill,
                    .combFill,
                    .shieldFill,
                    .cubeFill,
                    .shippingboxFill,
                    .clockFill,
                    .deskclockFill,
                    .alarmFill,
                    .stopwatchFill,
                    .timer,
                    .gamecontrollerFill,
                    .paintpaletteFill,
                    .cupAndSaucerFill,
                    .takeoutbagAndCupAndStrawFill,
                    .forkKnife,
                    .simcardFill,
                    .sdcardFill,
                    .esimFill,
                    .scalemassFill,
                    .globeDeskFill,
                    .giftFill,
                    .studentdesk,
                    .hourglass,
                    .lifepreserverFill,
                    .binocularsFill,
                    .lightbulbFill,
                ]
            case .devices:
                return [
                    .keyboard,
                    .printerFill,
                    .scannerFill,
                    .faxmachineFill,
                    .display,
                    .laptopcomputer,
                    .flipphone,
                    .candybarphone,
                    .flipphone,
                    .candybarphone,
                    .computermouseFill,
                    .headphones,
                    .earbuds,
                    .earbudsCaseFill,
                    .hifispeakerFill,
                    .avRemoteFill,
                    .mediastick,
                    .cableConnector,
                    .tvFill,
                    .sparklesTvFill,
                    .fourKTvFill,
                    .musicNoteTvFill,
                    .playTvFill,
                    .photoTv,
                    .hearingdeviceEar,
                ]
            case .gaming:
                return [
                    .flagCheckered,
                    .houseFill,
                    .gamecontrollerFill,
                    .rJoystickFill,
                    .dpadFill,
                    .triangleCircleFill,
                    .plusCircleFill,
                    .minusCircleFill,
                    .xmarkCircleFill,
                ]
            case .connectivity:
                return [
                    .externaldriveConnectedToLineBelowFill,
                    .network,
                    .boltHorizontalFill,
                    .wifi,
                    .dotRadiowavesLeftAndRight,
                    .dotRadiowavesForward,
                    .chartBarFill,
                ]
            case .transportation:
                return [
                    .airplane,
                    .carFill,
                    .boltCarFill,
                    .busFill,
                    .busDoubledeckerFill,
                    .tramFill,
                    .tramFillTunnel,
                    .cablecarFill,
                    .ferryFill,
                    .carFerryFill,
                    .boxTruckFill,
                    .bicycle,
                    .scooter,
                    .strollerFill,
                    .sailboatFill,
                    .fuelpumpFill,
                    .figureWalk,
                ]
            case .privacy:
                return [
                    .lockFill,
                    .lockShieldFill,
                    .lockOpenFill,
                    .keyFill,
                ]
            case .people:
                return [
                    .personFill,
                    .eyeFill,
                    .tshirtFill,
                    .brain,
                    .faceSmilingInverse,
                    .figureWalk,
                    .figureRoll,
                    .ear,
                    .hearingdeviceEar,
                    .handRaisedFill,
                    .handThumbsupFill,
                    .handThumbsdownFill,
                    .handWaveFill,
                    .handsClapFill,
                    .handsSparklesFill,
                ]
            case .camera:
                return [
                    .cameraFill,
                    .cameraMacro,
                    .photoFill,
                    .photoFillOnRectangleFill,
                    .photoStackFill,
                ]
            case .home:
                return [
                    .houseFill,
                    .lightbulbFill,
                    .showerFill,
                    .bathtubFill,
                    .sofaFill,
                    .washerFill,
                    .dishwasherFill,
                    .stoveFill,
                    .toiletFill,
                ]
            case .fitness:
                return [
                    .figureWalk,
                    .figureRun,
                    .figureRoll,
                    .figurePoolSwim,
                    .figureSnowboarding,
                    .figureSkiingDownhill,
                    .soccerball,
                    .baseballFill,
                    .basketballFill,
                    .footballFill,
                    .tennisballFill,
                    .dumbbellFill,
                ]
            case .nature:
                return [
                    .carrotFill,
                    .treeFill,
                    .fishFill,
                    .birdFill,
                    .lizardFill,
                    .flameFill,
                    .dropFill,
                    .boltFill,
                    .hareFill,
                    .tortoiseFill,
                    .pawprintFill,
                    .antFill,
                    .ladybugFill,
                    .leafFill,
                ]
            case .media:
                return [
                    .playFill,
                    .playSlashFill,
                    .pauseFill,
                    .stopFill,
                    .recordCircleFill,
                    .playpauseFill,
                    .backwardFill,
                    .forwardFill,
                    .shuffle,
                    .repeat,
                ]
            case .commerce:
                return [
                    .bagFill,
                    .cartFill,
                    .creditcardFill,
                    .giftcardFill,
                    .banknoteFill,
                    .dollarsignCircleFill,
                    .centsignCircleFill,
                    .yensignCircleFill,
                    .sterlingsignCircleFill,
                    .francsignCircleFill,
                    .florinsignCircleFill,
                    .turkishlirasignCircleFill,
                    .rublesignCircleFill,
                    .eurosignCircleFill,
                    .dongsignCircleFill,
                    .indianrupeesignCircleFill,
                    .tengesignCircleFill,
                    .pesetasignCircleFill,
                    .pesosignCircleFill,
                    .kipsignCircleFill,
                    .wonsignCircleFill,
                    .lirasignCircleFill,
                    .australsignCircleFill,
                    .hryvniasignCircleFill,
                    .nairasignCircleFill,
                    .guaranisignCircleFill,
                    .coloncurrencysignCircleFill,
                    .cedisignCircleFill,
                    .cruzeirosignCircleFill,
                    .tugriksignCircleFill,
                    .millsignCircleFill,
                    .shekelsignCircleFill,
                    .manatsignCircleFill,
                    .rupeesignCircleFill,
                    .bahtsignCircleFill,
                    .larisignCircleFill,
                    .bitcoinsignCircleFill,
                    .brazilianrealsignCircleFill,
                ]
            case .time:
                return [
                    .clockFill,
                    .deskclockFill,
                    .alarmFill,
                    .stopwatchFill,
                    .timer,
                    .hourglass,
                ]
            case .health:
                return [
                    .syringeFill,
                    .heartFill,
                    .eyeFill,
                    .facemaskFill,
                    .brain,
                    .bandageFill,
                    .bedDoubleFill,
                    .pillsFill,
                    .crossVialFill,
                    .crossFill,
                    .ear,
                    .staroflifeFill,
                    .stethoscope,
                ]
            case .shapes:
                return [
                    .circleFill,
                    .squareFill,
                    .triangleFill,
                    .diamondFill,
                    .pentagonFill,
                    .shieldFill,
                ]
            case .arrows:
                return [
                    .arrowshapeLeftFill,
                    .arrowshapeRightFill,
                    .chevronLeftCircleFill,
                    .chevronRightCircleFill,
                    .chevronUpCircleFill,
                    .chevronDownCircleFill,
                ]
            case .indices:
                return [
                    .questionmarkCircleFill,
                    .exclamationmarkCircleFill,
                    .dollarsignCircleFill,
                    .centsignCircleFill,
                    .yensignCircleFill,
                    .sterlingsignCircleFill,
                    .francsignCircleFill,
                    .florinsignCircleFill,
                    .turkishlirasignCircleFill,
                    .rublesignCircleFill,
                    .eurosignCircleFill,
                    .dongsignCircleFill,
                    .indianrupeesignCircleFill,
                    .tengesignCircleFill,
                    .pesetasignCircleFill,
                    .pesosignCircleFill,
                    .kipsignCircleFill,
                    .wonsignCircleFill,
                    .lirasignCircleFill,
                    .australsignCircleFill,
                    .hryvniasignCircleFill,
                    .nairasignCircleFill,
                    .guaranisignCircleFill,
                    .coloncurrencysignCircleFill,
                    .cedisignCircleFill,
                    .cruzeirosignCircleFill,
                    .tugriksignCircleFill,
                    .millsignCircleFill,
                    .shekelsignCircleFill,
                    .manatsignCircleFill,
                    .rupeesignCircleFill,
                    .bahtsignCircleFill,
                    .larisignCircleFill,
                    .bitcoinsignCircleFill,
                    .brazilianrealsignCircleFill,
                ]
            case .math:
                return [
                    .plusCircleFill,
                    .minusCircleFill,
                    .plusminusCircleFill,
                    .multiplyCircleFill,
                    .divideCircleFill,
                    .equalCircleFill,
                    .lessthanCircleFill,
                    .greaterthanCircleFill,
                    .numberCircleFill,
                ]
            }
        }
    }
}

// MARK: - Symbols

extension SFSymbol {

    // MARK: Communication

    public static let micFill = SFSymbol(category: .communication, systemName: "mic.fill")
    public static let arrowUpMessage = SFSymbol(category: .communication, systemName: "arrow.up.message")
    public static let bubbleLeftFill = SFSymbol(category: .communication, systemName: "bubble.left.fill")
    public static let quoteOpening = SFSymbol(category: .communication, systemName: "quote.opening")
    public static let phoneFill = SFSymbol(category: .communication, systemName: "phone.fill")
    public static let envelopeFill = SFSymbol(category: .communication, systemName: "envelope.fill")
    public static let envelopeOpenFill = SFSymbol(category: .communication, systemName: "envelope.open.fill")
    public static let waveform = SFSymbol(category: .communication, systemName: "waveform")
    public static let recordingtape = SFSymbol(category: .communication, systemName: "recordingtape")

    // MARK: Weather

    public static let sunMinFill = SFSymbol(category: .weather, systemName: "sun.min.fill")
    public static let sunMaxFill = SFSymbol(category: .weather, systemName: "sun.max.fill")
    public static let sunriseFill = SFSymbol(category: .weather, systemName: "sunrise.fill")
    public static let sunsetFill = SFSymbol(category: .weather, systemName: "sunset.fill")
    public static let sunAndHorizonFill = SFSymbol(category: .weather, systemName: "sun.and.horizon.fill")
    public static let sunDustFill = SFSymbol(category: .weather, systemName: "sun.dust.fill")
    public static let sunHazeFill = SFSymbol(category: .weather, systemName: "sun.haze.fill")
    public static let moonFill = SFSymbol(category: .weather, systemName: "moon.fill")
    public static let sparkles = SFSymbol(category: .weather, systemName: "sparkles")
    public static let moonStarsFill = SFSymbol(category: .weather, systemName: "moon.stars.fill")
    public static let cloudFill = SFSymbol(category: .weather, systemName: "cloud.fill")
    public static let cloudDrizzleFill = SFSymbol(category: .weather, systemName: "cloud.drizzle.fill")
    public static let cloudRainFill = SFSymbol(category: .weather, systemName: "cloud.rain.fill")
    public static let cloudHeavyrainFill = SFSymbol(category: .weather, systemName: "cloud.heavyrain.fill")
    public static let cloudFogFill = SFSymbol(category: .weather, systemName: "cloud.fog.fill")
    public static let cloudHailFill = SFSymbol(category: .weather, systemName: "cloud.hail.fill")
    public static let cloudSnowFill = SFSymbol(category: .weather, systemName: "cloud.snow.fill")
    public static let cloudSleetFill = SFSymbol(category: .weather, systemName: "cloud.sleet.fill")
    public static let cloudBoltFill = SFSymbol(category: .weather, systemName: "cloud.bolt.fill")
    public static let cloudBoltRainFill = SFSymbol(category: .weather, systemName: "cloud.bolt.rain.fill")
    public static let cloudSunFill = SFSymbol(category: .weather, systemName: "cloud.sun.fill")
    public static let cloudSunRainFill = SFSymbol(category: .weather, systemName: "cloud.sun.rain.fill")
    public static let cloudSunBoltFill = SFSymbol(category: .weather, systemName: "cloud.sun.bolt.fill")
    public static let cloudMoonFill = SFSymbol(category: .weather, systemName: "cloud.moon.fill")
    public static let cloudMoonRainFill = SFSymbol(category: .weather, systemName: "cloud.moon.rain.fill")
    public static let cloudMoonBoltFill = SFSymbol(category: .weather, systemName: "cloud.moon.bolt.fill")
    public static let smokeFill = SFSymbol(category: .weather, systemName: "smoke.fill")
    public static let wind = SFSymbol(category: .weather, systemName: "wind")
    public static let windSnow = SFSymbol(category: .weather, systemName: "wind.snow")
    public static let snowflake = SFSymbol(category: .weather, systemName: "snowflake")
    public static let tornado = SFSymbol(category: .weather, systemName: "tornado")
    public static let tropicalstorm = SFSymbol(category: .weather, systemName: "tropicalstorm")
    public static let hurricane = SFSymbol(category: .weather, systemName: "hurricane")
    public static let thermometerSunFill = SFSymbol(category: .weather, systemName: "thermometer.sun.fill")
    public static let thermometerSnowflake = SFSymbol(category: .weather, systemName: "thermometer.snowflake")
    public static let thermometer = SFSymbol(category: .weather, systemName: "thermometer")
    public static let humidityFill = SFSymbol(category: .weather, systemName: "humidity.fill")

    // MARK: Objects

    public static let pencil = SFSymbol(category: .objects, systemName: "pencil")
    public static let eraserFill = SFSymbol(category: .objects, systemName: "eraser.fill")
    public static let highlighter = SFSymbol(category: .objects, systemName: "highlighter")
    public static let trashFill = SFSymbol(category: .objects, systemName: "trash.fill")
    public static let folderFill = SFSymbol(category: .objects, systemName: "folder.fill")
    public static let trayFullFill = SFSymbol(category: .objects, systemName: "tray.full.fill")
    public static let archiveboxFill = SFSymbol(category: .objects, systemName: "archivebox.fill")
    public static let docFill = SFSymbol(category: .objects, systemName: "doc.fill")
    public static let note = SFSymbol(category: .objects, systemName: "note")
    public static let calendar = SFSymbol(category: .objects, systemName: "calendar")
    public static let bookFill = SFSymbol(category: .objects, systemName: "book.fill")
    public static let booksVerticalFill = SFSymbol(category: .objects, systemName: "books.vertical.fill")
    public static let bookClosedFill = SFSymbol(category: .objects, systemName: "book.closed.fill")
    public static let textBookClosedFill = SFSymbol(category: .objects, systemName: "text.book.closed.fill")
    public static let menucardFill = SFSymbol(category: .objects, systemName: "menucard.fill")
    public static let greetingcardFill = SFSymbol(category: .objects, systemName: "greetingcard.fill")
    public static let magazineFill = SFSymbol(category: .objects, systemName: "magazine.fill")
    public static let newspaperFill = SFSymbol(category: .objects, systemName: "newspaper.fill")
    public static let bookmarkFill = SFSymbol(category: .objects, systemName: "bookmark.fill")
    public static let rosette = SFSymbol(category: .objects, systemName: "rosette")
    public static let graduationcapFill = SFSymbol(category: .objects, systemName: "graduationcap.fill")
    public static let ticketFill = SFSymbol(category: .objects, systemName: "ticket.fill")
    public static let paperclip = SFSymbol(category: .objects, systemName: "paperclip")
    public static let link = SFSymbol(category: .objects, systemName: "link")
    public static let umbrellaFill = SFSymbol(category: .objects, systemName: "umbrella.fill")
    public static let megaphoneFill = SFSymbol(category: .objects, systemName: "megaphone.fill")
    public static let speakerFill = SFSymbol(category: .objects, systemName: "speaker.fill")
    public static let musicMic = SFSymbol(category: .objects, systemName: "music.mic")
    public static let magnifyingglass = SFSymbol(category: .objects, systemName: "magnifyingglass")
    public static let flagFill = SFSymbol(category: .objects, systemName: "flag.fill")
    public static let bellFill = SFSymbol(category: .objects, systemName: "bell.fill")
    public static let tagFill = SFSymbol(category: .objects, systemName: "tag.fill")
    public static let eyeglasses = SFSymbol(category: .objects, systemName: "eyeglasses")
    public static let flashlightOnFill = SFSymbol(category: .objects, systemName: "flashlight.on.fill")
    public static let gear = SFSymbol(category: .objects, systemName: "gear")
    public static let gearshapeFill = SFSymbol(category: .objects, systemName: "gearshape.fill")
    public static let scissors = SFSymbol(category: .objects, systemName: "scissors")
    public static let walletPassFill = SFSymbol(category: .objects, systemName: "wallet.pass.fill")
    public static let gyroscope = SFSymbol(category: .objects, systemName: "gyroscope")
    public static let gaugeLow = SFSymbol(category: .objects, systemName: "gauge.low")
    public static let speedometer = SFSymbol(category: .objects, systemName: "speedometer")
    public static let barometer = SFSymbol(category: .objects, systemName: "barometer")
    public static let metronomeFill = SFSymbol(category: .objects, systemName: "metronome.fill")
    public static let amplifier = SFSymbol(category: .objects, systemName: "amplifier")
    public static let diceFill = SFSymbol(category: .objects, systemName: "dice.fill")
    public static let pianokeysInverse = SFSymbol(category: .objects, systemName: "pianokeys.inverse")
    public static let tuningfork = SFSymbol(category: .objects, systemName: "tuningfork")
    public static let paintbrushFill = SFSymbol(category: .objects, systemName: "paintbrush.fill")
    public static let ruler = SFSymbol(category: .objects, systemName: "ruler")
    public static let rulerFill = SFSymbol(category: .objects, systemName: "ruler.fill")
    public static let levelFill = SFSymbol(category: .objects, systemName: "level.fill")
    public static let wrenchFill = SFSymbol(category: .objects, systemName: "wrench.fill")
    public static let hammerFill = SFSymbol(category: .objects, systemName: "hammer.fill")
    public static let screwdriverFill = SFSymbol(category: .objects, systemName: "screwdriver.fill")
    public static let eyedropperHalffull = SFSymbol(category: .objects, systemName: "eyedropper.halffull")
    public static let wrenchAndScrewdriverFill = SFSymbol(category: .objects, systemName: "wrench.and.screwdriver.fill")
    public static let scrollFill = SFSymbol(category: .objects, systemName: "scroll.fill")
    public static let briefcaseFill = SFSymbol(category: .objects, systemName: "briefcase.fill")
    public static let caseFill = SFSymbol(category: .objects, systemName: "case.fill")
    public static let latch2CaseFill = SFSymbol(category: .objects, systemName: "latch.2.case.fill")
    public static let suitcaseFill = SFSymbol(category: .objects, systemName: "suitcase.fill")
    public static let suitcaseCartFill = SFSymbol(category: .objects, systemName: "suitcase.cart.fill")
    public static let theatermasksFill = SFSymbol(category: .objects, systemName: "theatermasks.fill")
    public static let puzzlepieceExtensionFill = SFSymbol(category: .objects, systemName: "puzzlepiece.extension.fill")
    public static let puzzlepieceFill = SFSymbol(category: .objects, systemName: "puzzlepiece.fill")
    public static let buildingFill = SFSymbol(category: .objects, systemName: "building.fill")
    public static let building2Fill = SFSymbol(category: .objects, systemName: "building.2.fill")
    public static let pinFill = SFSymbol(category: .objects, systemName: "pin.fill")
    public static let mapFill = SFSymbol(category: .objects, systemName: "map.fill")
    public static let cpuFill = SFSymbol(category: .objects, systemName: "cpu.fill")
    public static let memorychipFill = SFSymbol(category: .objects, systemName: "memorychip.fill")
    public static let radioFill = SFSymbol(category: .objects, systemName: "radio.fill")
    public static let guitarsFill = SFSymbol(category: .objects, systemName: "guitars.fill")
    public static let strollerFill = SFSymbol(category: .objects, systemName: "stroller.fill")
    public static let sailboatFill = SFSymbol(category: .objects, systemName: "sailboat.fill")
    public static let tshirtFill = SFSymbol(category: .objects, systemName: "tshirt.fill")
    public static let filmFill = SFSymbol(category: .objects, systemName: "film.fill")
    public static let crownFill = SFSymbol(category: .objects, systemName: "crown.fill")
    public static let combFill = SFSymbol(category: .objects, systemName: "comb.fill")
    public static let cubeFill = SFSymbol(category: .objects, systemName: "cube.fill")
    public static let shippingboxFill = SFSymbol(category: .objects, systemName: "shippingbox.fill")
    public static let paintpaletteFill = SFSymbol(category: .objects, systemName: "paintpalette.fill")
    public static let cupAndSaucerFill = SFSymbol(category: .objects, systemName: "cup.and.saucer.fill")
    public static let takeoutbagAndCupAndStrawFill = SFSymbol(
        category: .objects, systemName: "takeoutbag.and.cup.and.straw.fill")
    public static let forkKnife = SFSymbol(category: .objects, systemName: "fork.knife")
    public static let simcardFill = SFSymbol(category: .objects, systemName: "simcard.fill")
    public static let sdcardFill = SFSymbol(category: .objects, systemName: "sdcard.fill")
    public static let esimFill = SFSymbol(category: .objects, systemName: "esim.fill")
    public static let scalemassFill = SFSymbol(category: .objects, systemName: "scalemass.fill")
    public static let globeDeskFill = SFSymbol(category: .objects, systemName: "globe.desk.fill")
    public static let giftFill = SFSymbol(category: .objects, systemName: "gift.fill")
    public static let studentdesk = SFSymbol(category: .objects, systemName: "studentdesk")
    public static let lifepreserverFill = SFSymbol(category: .objects, systemName: "lifepreserver.fill")
    public static let binocularsFill = SFSymbol(category: .objects, systemName: "binoculars.fill")

    // MARK: Devices

    public static let keyboard = SFSymbol(category: .devices, systemName: "keyboard")
    public static let printerFill = SFSymbol(category: .devices, systemName: "printer.fill")
    public static let scannerFill = SFSymbol(category: .devices, systemName: "scanner.fill")
    public static let faxmachineFill = SFSymbol(category: .devices, systemName: "faxmachine.fill")
    public static let display = SFSymbol(category: .devices, systemName: "display")
    public static let laptopcomputer = SFSymbol(category: .devices, systemName: "laptopcomputer")
    public static let flipphone = SFSymbol(category: .devices, systemName: "flipphone")
    public static let candybarphone = SFSymbol(category: .devices, systemName: "candybarphone")
    public static let computermouseFill = SFSymbol(category: .devices, systemName: "computermouse.fill")
    public static let headphones = SFSymbol(category: .devices, systemName: "headphones")
    public static let earbuds = SFSymbol(category: .devices, systemName: "earbuds")
    public static let earbudsCaseFill = SFSymbol(category: .devices, systemName: "earbuds.case.fill")
    public static let hifispeakerFill = SFSymbol(category: .devices, systemName: "hifispeaker.fill")
    public static let avRemoteFill = SFSymbol(category: .devices, systemName: "av.remote.fill")
    public static let mediastick = SFSymbol(category: .devices, systemName: "mediastick")
    public static let cableConnector = SFSymbol(category: .devices, systemName: "cable.connector")
    public static let tvFill = SFSymbol(category: .devices, systemName: "tv.fill")
    public static let sparklesTvFill = SFSymbol(category: .devices, systemName: "sparkles.tv.fill")
    public static let fourKTvFill = SFSymbol(category: .devices, systemName: "4k.tv.fill")
    public static let musicNoteTvFill = SFSymbol(category: .devices, systemName: "music.note.tv.fill")
    public static let playTvFill = SFSymbol(category: .devices, systemName: "play.tv.fill")
    public static let photoTv = SFSymbol(category: .devices, systemName: "photo.tv")
    public static let hearingdeviceEar = SFSymbol(category: .devices, systemName: "hearingdevice.ear")

    // MARK: Camera

    public static let cameraFill = SFSymbol(category: .camera, systemName: "camera.fill")
    public static let cameraMacro = SFSymbol(category: .camera, systemName: "camera.macro")
    public static let photoFill = SFSymbol(category: .camera, systemName: "photo.fill")
    public static let photoFillOnRectangleFill = SFSymbol(category: .camera, systemName: "photo.fill.on.rectangle.fill")
    public static let photoStackFill = SFSymbol(category: .camera, systemName: "photo.stack.fill")

    // MARK: Gaming

    public static let flagCheckered = SFSymbol(category: .gaming, systemName: "flag.checkered")
    public static let gamecontrollerFill = SFSymbol(category: .gaming, systemName: "gamecontroller.fill")
    public static let dpadFill = SFSymbol(category: .gaming, systemName: "dpad.fill")
    public static let rJoystickFill = SFSymbol(category: .gaming, systemName: "r.joystick.fill")
    public static let triangleCircleFill = SFSymbol(category: .gaming, systemName: "triangle.circle.fill")
    public static let xmarkCircleFill = SFSymbol(category: .gaming, systemName: "xmark.circle.fill")

    // MARK: Connectivity

    public static let externaldriveConnectedToLineBelowFill = SFSymbol(
        category: .connectivity, systemName: "externaldrive.connected.to.line.below.fill")
    public static let network = SFSymbol(category: .connectivity, systemName: "network")
    public static let boltHorizontalFill = SFSymbol(category: .connectivity, systemName: "bolt.horizontal.fill")
    public static let wifi = SFSymbol(category: .connectivity, systemName: "wifi")
    public static let dotRadiowavesLeftAndRight = SFSymbol(
        category: .connectivity, systemName: "dot.radiowaves.left.and.right")
    public static let dotRadiowavesForward = SFSymbol(category: .connectivity, systemName: "dot.radiowaves.forward")
    public static let chartBarFill = SFSymbol(category: .connectivity, systemName: "chart.bar.fill")

    // MARK: Transportation

    public static let airplane = SFSymbol(category: .transportation, systemName: "airplane")
    public static let carFill = SFSymbol(category: .transportation, systemName: "car.fill")
    public static let boltCarFill = SFSymbol(category: .transportation, systemName: "bolt.car.fill")
    public static let busFill = SFSymbol(category: .transportation, systemName: "bus.fill")
    public static let busDoubledeckerFill = SFSymbol(category: .transportation, systemName: "bus.doubledecker.fill")
    public static let tramFill = SFSymbol(category: .transportation, systemName: "tram.fill")
    public static let tramFillTunnel = SFSymbol(category: .transportation, systemName: "tram.fill.tunnel")
    public static let cablecarFill = SFSymbol(category: .transportation, systemName: "cablecar.fill")
    public static let ferryFill = SFSymbol(category: .transportation, systemName: "ferry.fill")
    public static let carFerryFill = SFSymbol(category: .transportation, systemName: "car.ferry.fill")
    public static let boxTruckFill = SFSymbol(category: .transportation, systemName: "box.truck.fill")
    public static let bicycle = SFSymbol(category: .transportation, systemName: "bicycle")
    public static let scooter = SFSymbol(category: .transportation, systemName: "scooter")
    public static let fuelpumpFill = SFSymbol(category: .transportation, systemName: "fuelpump.fill")

    // MARK: Privacy & Security

    public static let lockFill = SFSymbol(category: .objects, systemName: "lock.fill")
    public static let lockShieldFill = SFSymbol(category: .objects, systemName: "lock.shield.fill")
    public static let lockOpenFill = SFSymbol(category: .objects, systemName: "lock.open.fill")
    public static let keyFill = SFSymbol(category: .objects, systemName: "key.fill")

    // MARK: People

    public static let personFill = SFSymbol(category: .people, systemName: "person.fill")
    public static let faceSmilingInverse = SFSymbol(category: .people, systemName: "face.smiling.inverse")
    public static let handRaisedFill = SFSymbol(category: .people, systemName: "hand.raised.fill")
    public static let handThumbsupFill = SFSymbol(category: .people, systemName: "hand.thumbsup.fill")
    public static let handThumbsdownFill = SFSymbol(category: .people, systemName: "hand.thumbsdown.fill")
    public static let handWaveFill = SFSymbol(category: .people, systemName: "hand.wave.fill")
    public static let handsClapFill = SFSymbol(category: .people, systemName: "hands.clap.fill")
    public static let handsSparklesFill = SFSymbol(category: .people, systemName: "hands.sparkles.fill")

    // MARK: Home

    public static let houseFill = SFSymbol(category: .home, systemName: "house.fill")
    public static let lightbulbFill = SFSymbol(category: .home, systemName: "lightbulb.fill")
    public static let showerFill = SFSymbol(category: .home, systemName: "shower.fill")
    public static let bathtubFill = SFSymbol(category: .home, systemName: "bathtub.fill")
    public static let sofaFill = SFSymbol(category: .home, systemName: "sofa.fill")
    public static let washerFill = SFSymbol(category: .home, systemName: "washer.fill")
    public static let dishwasherFill = SFSymbol(category: .home, systemName: "dishwasher.fill")
    public static let stoveFill = SFSymbol(category: .home, systemName: "stove.fill")
    public static let toiletFill = SFSymbol(category: .home, systemName: "toilet.fill")

    // MARK: Fitness

    public static let figureWalk = SFSymbol(category: .fitness, systemName: "figure.walk")
    public static let figureRun = SFSymbol(category: .fitness, systemName: "figure.run")
    public static let figureRoll = SFSymbol(category: .fitness, systemName: "figure.roll")
    public static let figurePoolSwim = SFSymbol(category: .fitness, systemName: "figure.pool.swim")
    public static let figureSnowboarding = SFSymbol(category: .fitness, systemName: "figure.snowboarding")
    public static let figureSkiingDownhill = SFSymbol(category: .fitness, systemName: "figure.skiing.downhill")
    public static let soccerball = SFSymbol(category: .fitness, systemName: "soccerball")
    public static let baseballFill = SFSymbol(category: .fitness, systemName: "baseball.fill")
    public static let basketballFill = SFSymbol(category: .fitness, systemName: "basketball.fill")
    public static let footballFill = SFSymbol(category: .fitness, systemName: "football.fill")
    public static let tennisballFill = SFSymbol(category: .fitness, systemName: "tennisball.fill")
    public static let dumbbellFill = SFSymbol(category: .fitness, systemName: "dumbbell.fill")

    // MARK: Nature

    public static let flameFill = SFSymbol(category: .nature, systemName: "flame.fill")
    public static let dropFill = SFSymbol(category: .nature, systemName: "drop.fill")
    public static let boltFill = SFSymbol(category: .nature, systemName: "bolt.fill")
    public static let hareFill = SFSymbol(category: .nature, systemName: "hare.fill")
    public static let tortoiseFill = SFSymbol(category: .nature, systemName: "tortoise.fill")
    public static let pawprintFill = SFSymbol(category: .nature, systemName: "pawprint.fill")
    public static let antFill = SFSymbol(category: .nature, systemName: "ant.fill")
    public static let ladybugFill = SFSymbol(category: .nature, systemName: "ladybug.fill")
    public static let leafFill = SFSymbol(category: .nature, systemName: "leaf.fill")
    public static let carrotFill = SFSymbol(category: .nature, systemName: "carrot.fill")
    public static let treeFill = SFSymbol(category: .nature, systemName: "tree.fill")
    public static let fishFill = SFSymbol(category: .nature, systemName: "fish.fill")
    public static let birdFill = SFSymbol(category: .nature, systemName: "bird.fill")
    public static let lizardFill = SFSymbol(category: .nature, systemName: "lizard.fill")

    // MARK: Media

    public static let playFill = SFSymbol(category: .media, systemName: "play.fill")
    public static let playSlashFill = SFSymbol(category: .media, systemName: "play.slash.fill")
    public static let pauseFill = SFSymbol(category: .media, systemName: "pause.fill")
    public static let stopFill = SFSymbol(category: .media, systemName: "stop.fill")
    public static let recordCircleFill = SFSymbol(category: .media, systemName: "record.circle.fill")
    public static let playpauseFill = SFSymbol(category: .media, systemName: "playpause.fill")
    public static let backwardFill = SFSymbol(category: .media, systemName: "backward.fill")
    public static let forwardFill = SFSymbol(category: .media, systemName: "forward.fill")
    public static let shuffle = SFSymbol(category: .media, systemName: "shuffle")
    public static let `repeat` = SFSymbol(category: .media, systemName: "repeat")

    // MARK: Commerce

    public static let bagFill = SFSymbol(category: .commerce, systemName: "bag.fill")
    public static let cartFill = SFSymbol(category: .commerce, systemName: "cart.fill")
    public static let creditcardFill = SFSymbol(category: .commerce, systemName: "creditcard.fill")
    public static let giftcardFill = SFSymbol(category: .commerce, systemName: "giftcard.fill")
    public static let banknoteFill = SFSymbol(category: .commerce, systemName: "banknote.fill")

    // MARK: Time

    public static let clockFill = SFSymbol(category: .time, systemName: "clock.fill")
    public static let deskclockFill = SFSymbol(category: .time, systemName: "deskclock.fill")
    public static let alarmFill = SFSymbol(category: .time, systemName: "alarm.fill")
    public static let stopwatchFill = SFSymbol(category: .time, systemName: "stopwatch.fill")
    public static let timer = SFSymbol(category: .time, systemName: "timer")
    public static let hourglass = SFSymbol(category: .time, systemName: "hourglass")

    // MARK: Health

    public static let heartFill = SFSymbol(category: .health, systemName: "heart.fill")
    public static let crossFill = SFSymbol(category: .health, systemName: "cross.fill")
    public static let bandageFill = SFSymbol(category: .health, systemName: "bandage.fill")
    public static let eyeFill = SFSymbol(category: .health, systemName: "eye.fill")
    public static let facemaskFill = SFSymbol(category: .health, systemName: "facemask.fill")
    public static let brain = SFSymbol(category: .health, systemName: "brain")
    public static let pillsFill = SFSymbol(category: .health, systemName: "pills.fill")
    public static let crossVialFill = SFSymbol(category: .health, systemName: "cross.vial.fill")
    public static let staroflifeFill = SFSymbol(category: .health, systemName: "staroflife.fill")
    public static let bedDoubleFill = SFSymbol(category: .health, systemName: "bed.double.fill")
    public static let ear = SFSymbol(category: .health, systemName: "ear")
    public static let syringeFill = SFSymbol(category: .health, systemName: "syringe.fill")
    public static let stethoscope = SFSymbol(category: .health, systemName: "stethoscope")

    // MARK: Shapes

    public static let circleFill = SFSymbol(category: .shapes, systemName: "circle.fill")
    public static let squareFill = SFSymbol(category: .shapes, systemName: "square.fill")
    public static let triangleFill = SFSymbol(category: .shapes, systemName: "triangle.fill")
    public static let diamondFill = SFSymbol(category: .shapes, systemName: "diamond.fill")
    public static let pentagonFill = SFSymbol(category: .shapes, systemName: "pentagon.fill")
    public static let shieldFill = SFSymbol(category: .shapes, systemName: "shield.fill")

    // MARK: Arrows

    public static let arrowshapeLeftFill = SFSymbol(category: .arrows, systemName: "arrowshape.left.fill")
    public static let arrowshapeRightFill = SFSymbol(category: .arrows, systemName: "arrowshape.right.fill")
    public static let chevronLeftCircleFill = SFSymbol(category: .arrows, systemName: "chevron.left.circle.fill")
    public static let chevronRightCircleFill = SFSymbol(category: .arrows, systemName: "chevron.right.circle.fill")
    public static let chevronUpCircleFill = SFSymbol(category: .arrows, systemName: "chevron.up.circle.fill")
    public static let chevronDownCircleFill = SFSymbol(category: .arrows, systemName: "chevron.down.circle.fill")

    // MARK: Indices

    public static let questionmarkCircleFill = SFSymbol(category: .indices, systemName: "questionmark.circle.fill")
    public static let exclamationmarkCircleFill = SFSymbol(
        category: .indices, systemName: "exclamationmark.circle.fill")
    public static let dollarsignCircleFill = SFSymbol(category: .indices, systemName: "dollarsign.circle.fill")
    public static let centsignCircleFill = SFSymbol(category: .indices, systemName: "centsign.circle.fill")
    public static let yensignCircleFill = SFSymbol(category: .indices, systemName: "yensign.circle.fill")
    public static let sterlingsignCircleFill = SFSymbol(category: .indices, systemName: "sterlingsign.circle.fill")
    public static let francsignCircleFill = SFSymbol(category: .indices, systemName: "francsign.circle.fill")
    public static let florinsignCircleFill = SFSymbol(category: .indices, systemName: "florinsign.circle.fill")
    public static let turkishlirasignCircleFill = SFSymbol(
        category: .indices, systemName: "turkishlirasign.circle.fill")
    public static let rublesignCircleFill = SFSymbol(category: .indices, systemName: "rublesign.circle.fill")
    public static let eurosignCircleFill = SFSymbol(category: .indices, systemName: "eurosign.circle.fill")
    public static let dongsignCircleFill = SFSymbol(category: .indices, systemName: "dongsign.circle.fill")
    public static let indianrupeesignCircleFill = SFSymbol(
        category: .indices, systemName: "indianrupeesign.circle.fill")
    public static let tengesignCircleFill = SFSymbol(category: .indices, systemName: "tengesign.circle.fill")
    public static let pesetasignCircleFill = SFSymbol(category: .indices, systemName: "pesetasign.circle.fill")
    public static let pesosignCircleFill = SFSymbol(category: .indices, systemName: "pesosign.circle.fill")
    public static let kipsignCircleFill = SFSymbol(category: .indices, systemName: "kipsign.circle.fill")
    public static let wonsignCircleFill = SFSymbol(category: .indices, systemName: "wonsign.circle.fill")
    public static let lirasignCircleFill = SFSymbol(category: .indices, systemName: "lirasign.circle.fill")
    public static let australsignCircleFill = SFSymbol(category: .indices, systemName: "australsign.circle.fill")
    public static let hryvniasignCircleFill = SFSymbol(category: .indices, systemName: "hryvniasign.circle.fill")
    public static let nairasignCircleFill = SFSymbol(category: .indices, systemName: "nairasign.circle.fill")
    public static let guaranisignCircleFill = SFSymbol(category: .indices, systemName: "guaranisign.circle.fill")
    public static let coloncurrencysignCircleFill = SFSymbol(
        category: .indices, systemName: "coloncurrencysign.circle.fill")
    public static let cedisignCircleFill = SFSymbol(category: .indices, systemName: "cedisign.circle.fill")
    public static let cruzeirosignCircleFill = SFSymbol(category: .indices, systemName: "cruzeirosign.circle.fill")
    public static let tugriksignCircleFill = SFSymbol(category: .indices, systemName: "tugriksign.circle.fill")
    public static let millsignCircleFill = SFSymbol(category: .indices, systemName: "millsign.circle.fill")
    public static let shekelsignCircleFill = SFSymbol(category: .indices, systemName: "shekelsign.circle.fill")
    public static let manatsignCircleFill = SFSymbol(category: .indices, systemName: "manatsign.circle.fill")
    public static let rupeesignCircleFill = SFSymbol(category: .indices, systemName: "rupeesign.circle.fill")
    public static let bahtsignCircleFill = SFSymbol(category: .indices, systemName: "bahtsign.circle.fill")
    public static let larisignCircleFill = SFSymbol(category: .indices, systemName: "larisign.circle.fill")
    public static let bitcoinsignCircleFill = SFSymbol(category: .indices, systemName: "bitcoinsign.circle.fill")
    public static let brazilianrealsignCircleFill = SFSymbol(
        category: .indices, systemName: "brazilianrealsign.circle.fill")

    // MARK: Math

    public static let plusCircleFill = SFSymbol(category: .math, systemName: "plus.circle.fill")
    public static let minusCircleFill = SFSymbol(category: .math, systemName: "minus.circle.fill")
    public static let plusminusCircleFill = SFSymbol(category: .math, systemName: "plusminus.circle.fill")
    public static let multiplyCircleFill = SFSymbol(category: .math, systemName: "multiply.circle.fill")
    public static let divideCircleFill = SFSymbol(category: .math, systemName: "divide.circle.fill")
    public static let equalCircleFill = SFSymbol(category: .math, systemName: "equal.circle.fill")
    public static let lessthanCircleFill = SFSymbol(category: .math, systemName: "lessthan.circle.fill")
    public static let greaterthanCircleFill = SFSymbol(category: .math, systemName: "greaterthan.circle.fill")
    public static let numberCircleFill = SFSymbol(category: .math, systemName: "number.circle.fill")
}
