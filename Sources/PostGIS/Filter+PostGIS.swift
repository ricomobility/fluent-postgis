
import Fluent

extension DatabaseQuery.Filter {
    public static func gis(_ field: FieldKey, withing metters: Int, from point: Point) -> Self {
        .sql(raw: """
ST_DWithin(
    ST_GeographyFromText(ST_AsText(\(field.description))),
    ST_GeogFromText('POINT(\(point.x) \(point.y))'),
    \(metters)
)
""")
    }
    
    public static func gis(_ field: FieldKey, within bbox: [Double]) -> Self {
        let stringBox = bbox.map{String(describing: $0)}.joined(separator: ", ")
        return .sql(raw: "\(field.description) && ST_MakeEnvelope(\(stringBox), 4326)")
    }
}
